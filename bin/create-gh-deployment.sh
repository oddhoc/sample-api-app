#!/bin/bash -e

curl --user "${GITHUB_USER}:${GITHUB_TOKEN}" -sSL -X POST -d '
{
  "ref": "refs/heads/master",
  "payload": {
    "do": "it"
  },
  "description": "triggered via circleci"
}' https://api.github.com/repos/oddhoc/sample-api-app/deployments
