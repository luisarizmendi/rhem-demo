#!/usr/bin/env bash
set -euo pipefail

show_help() {
    cat <<EOF
Usage: $0 <github_token> <owner> <package_name> [owner_type]

Delete all versions of a container image in GitHub Container Registry (GHCR).

Arguments:
  github_token   GitHub personal access token with 'delete:packages' and 'read:packages' scopes
  owner          The username or organization name that owns the package
  package_name   The GHCR container package name (without 'ghcr.io/...')
  owner_type     (Optional) 'user' or 'org' (defaults to 'user')

Examples:
  # Delete all versions of a user-owned image
  $0 ghp_xxx myusername myimage

  # Delete all versions of an org-owned image
  $0 ghp_xxx myorg myimage org

Notes:
  - Requires 'jq' installed
  - Deletes ALL tags/versions of the given image
EOF
}

# ---- Check for --help ----
if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
    show_help
    exit 0
fi

# ---- Input parsing ----
TOKEN="${1:-}"
OWNER="${2:-}"
PACKAGE="${3:-}"
OWNER_TYPE="${4:-user}"

# ---- Validations ----
if [[ -z "$TOKEN" || -z "$OWNER" || -z "$PACKAGE" ]]; then
    echo "❌ Error: Missing required arguments."
    echo "Run '$0 --help' for usage."
    exit 1
fi

if [[ "$OWNER_TYPE" != "user" && "$OWNER_TYPE" != "org" ]]; then
    echo "❌ Error: owner_type must be 'user' or 'org'."
    exit 1
fi

# ---- API setup ----
API_BASE="https://api.github.com"
PACKAGE_URL="$API_BASE/$OWNER_TYPE/$OWNER/packages/container/$PACKAGE/versions"

echo "🔍 Target:"
echo "  - Owner Type: $OWNER_TYPE"
echo "  - Owner: $OWNER"
echo "  - Package: $PACKAGE"
echo "----------------------------------------"

# ---- Delete loop ----
while : ; do
    VERSION_IDS=$(curl -s -H "Accept: application/vnd.github+json" \
                       -H "Authorization: Bearer $TOKEN" \
                       "$PACKAGE_URL" | jq '.[].id')

    if [[ -z "$VERSION_IDS" ]]; then
        echo "✅ No more versions found. All deleted."
        break
    fi

    echo "$VERSION_IDS" | while read -r VID; do
        if [[ -n "$VID" ]]; then
            echo "🗑  Deleting version ID $VID..."
            curl -s -X DELETE \
                 -H "Accept: application/vnd.github+json" \
                 -H "Authorization: Bearer $TOKEN" \
                 "$PACKAGE_URL/$VID" \
                 && echo "   ➜ Deleted."
        fi
    done
done
