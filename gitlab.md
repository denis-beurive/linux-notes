# Gitlab

## Get the list of groups

```bash
readonly BASE_URL=https://gitlab.company.com
readonly OAUTH_TOKEN=xxx

curl -sS --insecure --header "Authorization: Bearer ${OAUTH_TOKEN}" "${BASE_URL}/api/v4/groups"

# or, if you only need to keep specific values (here: "id" and "name"):

curl -sS --insecure --header "Authorization: Bearer ${OAUTH_TOKEN}" "${BASE_URL}/api/v4/groups" | jq ".[] | [.name, .id] | @csv"
```

## Clone all projects owned by a given group

```bash
#!/usr/bin/env bash
#
# Configure:
#   * BASE_URL: the Gitlab API base URL
#   * OAUTH_TOKEN: your Gitlan authentication tocken
#   * GROUP_ID: the ID of the Gitlab group
#   * HEADER_FILE: path to a temporary file
#   * PROJECTS_PER_PAGE: number of projects retrieved from one GET request to the Gitlab API

readonly BASE_URL=https://gitlab.company.com
readonly OAUTH_TOKEN=xxx
readonly GROUP_ID=10
readonly HEADER_FILE=/tmp/curl-header.txt
readonly PROJECTS_PER_PAGE=5

git config --global credential.helper store

declare -i page=1
declare projects
declare url
declare stripper_url

while true
do
  # Retrieve (at most) $PROJECTS_PER_PAGE projects
  rm -f "${HEADER_FILE}"
  projects=$(curl -sS -D "${HEADER_FILE}" --insecure --header "Authorization: Bearer ${OAUTH_TOKEN}" "${BASE_URL}/api/v4/groups/${GROUP_ID}/projects?per_page=${PROJECTS_PER_PAGE}&page=${page}" | jq ".[] | .http_url_to_repo")
  page="$(cat "${HEADER_FILE}" | tr -d '\r' | grep -E '^X-Next-Page: ' | sed -E 's/^.+([[:digit:]]+)/\1/')"
  if [[ 0 == "${page}" ]]; then
    break
  fi

  # Clone the projects
  for url in ${projects}; do
    stripper_url=$(echo "${url}" | sed -E 's/^"//' | sed -E 's/"$//')
    git -c http.sslVerify=false clone "${stripper_url}"
  done
done

rm -f "${HEADER_FILE}"
```

