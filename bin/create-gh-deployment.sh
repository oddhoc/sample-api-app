#!/bin/bash -e

curl --user "${GITHUB_USER}:${GITHUB_TOKEN}" -sSL -X POST -d '
{
  "description": "triggered via circleci",
  "ref": "refs/heads/master",
  "payload": {
    "do": "it"
  },
  "required_contexts": [
    "ci/circleci: test",
    "ci/circleci: build"
  ]
}' https://api.github.com/repos/oddhoc/sample-api-app/deployments
