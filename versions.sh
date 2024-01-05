#!/usr/bin/env bash
set -Eeuo pipefail

supportedNodeVersions=(
	20
	18
)
supportedAlpineVersions=(
	3.18
	3.17
)
defaultNodeVersion="${supportedNodeVersions[0]}"
defaultAlpineVersion="${supportedAlpineVersions[0]}"

versions=( "$@" )
if [ ${#versions[@]} -eq 0 ]; then
	versions=( */ )
	json='{}'
else
	json="$(< versions.json)"
fi
versions=( "${versions[@]%/}" )

upstreamVersions=$(wget -qO- 'https://registry.npmjs.org/mongo-express' | jq -r '.versions | keys | .[]')

for version in "${versions[@]}"; do
	export version

    versionPattern="^${version/\./\\.}\.[0-9]*$"
    filteredVersions=($(printf "%s\n" ${upstreamVersions[*]} | grep -E "${versionPattern}"))
    fullVersion="${filteredVersions[${#filteredVersions[@]}-1]}"

    echo "$version: $fullVersion"
    
    export fullVersion="$fullVersion"
    export nodeVersion="${supportedNodeVersions[${#supportedNodeVersions[@]}-1]}"
    export alpineVersion="${supportedAlpineVersions[${#supportedAlpineVersions[@]}-1]}"

    for node in "${supportedNodeVersions[@]}"; do
        variants+=( "${supportedAlpineVersions[@]/#/$node-alpine}" )
    done
    
    doc='{}'
    for variant in "${variants[@]}"; do
		doc="$(jq <<<"$doc" -c --arg v "$variant" '
			.variants += [ $v ]
		')"
	done
    unset variants

    # TODO: Add way to pin default Node and Alpine for specific versions
    json="$(jq <<<"$json" -c --argjson doc "$doc" '
		.[env.version] = ({
			version: env.fullVersion,
            node: env.nodeVersion,
            alpine: env.alpineVersion,
            variants: $doc.variants
		})
	')"
done

jq <<<"$json" -S . > versions.json
