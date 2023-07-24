# push-python-jfrog-action
Example action to push python packages to JFrog using custom defaults. Allows dev teams to use the action without configuration.

### Setup this action in your own org
1. Forklift this repo into your org
2. Update line 6 of action.yml to include a link to a wiki describing how to get a username and access token for your company Artifactory instance.
3. Update line 16 to include the BASE URL of your Artifactory instance. Something like "https://hashtagcyber.jfrog.io/artifactory"
4. The artifactory-repo input assumes that your artifactory repository and github repository will have the same name. If that is not the case, you have two choices:
    - Update the logic in entrypoint.sh and action.yml to generate the correct repository name.
    - Delete the "default" value in action.yml. This will force teams to enter their artifactory repo name.
5. Profit

**Warning**
If your artifactory repository name requires a '/', you MUST edit the logic in entrypoint.sh


### Create a workflow in your org using this action
1. Follow the steps above to expose the action
2. Create the following secrets in the repository you want to use the action for:
    - ARTIFACTORY_USER
    - ARTIFACTORY_TOKEN
3. Create a workflow file similar to below. Be sure to update the final "uses" entry to be the name of your action.
```
#build-test-publish.yml
name: Publish this package to Company Artifactory

on:
  pull_request:
    branches:
      - main
    types: [closed]

jobs:
  build-test-publish:
    if: ${{ github.event.pull_request.merged }}
    name: Build, Test, Publish
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - name: Set up Python
      uses: actions/setup-python@v4
      with:
        python-version: "3.x"
    - name: Install Coverage
      run: >-
        python3 -m pip install coverage
    - name: Install build tools
      run: >-
        python3 -m pip install build --user
    - name: Build package
      run: >-
        python3 -m build --sdist --wheel --outdir dist/
    - name: Install package
      run: >-
        python3 -m pip install dist/*.whl
    - name: Run Unit Tests
      run: >-
        coverage run -m unittest discover -v && coverage report -m --skip-empty --omit 'tests/*' --fail-under=75 
    - name: Publish to Artifactory
      if: startsWith(github.ref, 'refs/tags')
      uses: hashtagcyber/push-python-jfrog-action
```
