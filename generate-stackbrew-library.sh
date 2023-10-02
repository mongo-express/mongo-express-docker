#!/usr/bin/env bash
set -Eeuo pipefail

declare -A aliases=(
	[1.0]='1 latest'
)

self="$(basename "$BASH_SOURCE")"
cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

if [ "$#" -eq 0 ]; then
	versions="$(jq -r 'keys | map(@sh) | join(" ")' versions.json)"
	eval "set -- $versions"
fi

# sort version numbers with highest first
IFS=$'\n'; set -- $(sort -rV <<<"$*"); unset IFS

# get the most recent commit which modified any of "$@"
fileCommit() {
	git log -1 --format='format:%H' HEAD -- "$@"
}

# get the most recent commit which modified "$1/Dockerfile" or any file COPY'd from "$1/Dockerfile"
dirCommit() {
	local dir="$1"; shift
	(
		cd "$dir"
		files="$(
			git show HEAD:./Dockerfile | awk '
				toupper($1) == "COPY" {
					for (i = 2; i < NF; i++) {
						if ($i ~ /^--from=/) {
							next
						}
						print $i
					}
				}
			'
		)"
		fileCommit Dockerfile $files
	)
}

commit="$(git log -1 --format='format:%H')"
cat <<-EOH
# this file is generated via https://github.com/mongo-express/mongo-express-docker/blob/$commit/$self

Maintainers: Nick Cox <nickcox1008@gmail.com> (@knickers),
             John Steel <john@jskw.dev> (@BlackthornYugen)
GitRepo: https://github.com/mongo-express/mongo-express-docker.git
GitCommit: $commit
EOH

# prints "$2$1$3$1...$N"
join() {
	local sep="$1"; shift
	local out; printf -v out "${sep//%/%%}%s" "$@"
	echo "${out#"$sep"}"
}

for version; do
	export version

	variants="$(jq -r '.[env.version].variants | map(@sh) | join(" ")' versions.json)"
	eval "variants=( $variants )"

	defaultAlpine="$(jq -r '.[env.version].alpine' versions.json)"
	defaultNode="$(jq -r '.[env.version].node' versions.json)"

	fullVersion="$(jq -r '.[env.version].version' versions.json)"

	# ex: 9.6.22, 13.3, or 14beta2
	versionAliases=(
		$fullVersion
	)
	# skip unadorned "version" on prereleases
	# ex: 9.6, 13, or 14
	case "$fullVersion" in
		*alpha* | *beta* | *rc*) ;;
		*) versionAliases+=( $version ) ;;
	esac
	# ex: 9 or latest
	# shellcheck disable=SC2206
	versionAliases+=(
		${aliases[$version]:-}
	)

	for variant in "${variants[@]}"; do
		versionAliasesCopy=( "${versionAliases[@]}" )
		dir="$version/$variant"
		commit="$(dirCommit "$dir")"

		IFS='-' read -ra PARTS <<< "$variant"
		node="${PARTS[0]}"
		alpine="${PARTS[1]}"

		latest=false
		if [ "${versionAliasesCopy[${#versionAliasesCopy[@]}-1]}" = "latest" ]; then
			unset "versionAliasesCopy[${#versionAliasesCopy[@]}-1]"
			latest=true
		fi

		if [ "${node}" = "${defaultNode}" ] && [ "${alpine}" = "alpine${defaultAlpine}" ]; then
			variantAliases=( "${versionAliasesCopy[@]}" "${versionAliasesCopy[@]/%/-$defaultNode}" "${versionAliasesCopy[@]/%/-$variant}" )
			if [ "${latest}" ]; then
				variantAliases+=( 'latest' )
			fi
		else
			if [ "${alpine}" = "alpine${defaultAlpine}" ]; then
				variantAliases=( "${versionAliasesCopy[@]/%/-$node}" "${versionAliasesCopy[@]/%/-$variant}" )
			else
				variantAliases=( "${versionAliasesCopy[@]/%/-$variant}" )
			fi
		fi

		cat <<-EOE

			Tags: $(join ', ' "${variantAliases[@]}")
			Architectures: amd64, arm64v8
			GitCommit: $commit
			Directory: $dir
		EOE
	done
done
