<p align="center">
  <img src="https://consuma.ai/static/media/logowithname.9e26c0e0.svg" alt="Consuma" height="50" />
</p>

# Release Management v1

This action is used to create a tag, push it to the repository and create a new release.
It will be used in every project to automate the release process.

## Usage

**A quick important note: This action will only work if the repository has at least one tag in the format `*.*.*` This is because the action uses the latest tag to determine the next version number. A future version of this action will remove this limitation.**


Save the following snippet in a file named `release.yml` in the `.github/workflows` directory of your repository.

```yaml
name: Merge and Release Management

on:
  workflow_dispatch:
    inputs:
      typeOfRelease:
        description: 'Type of Release (major, minor, patch, custom)'
        required: true
        default: 'patch'
        type: choice
        options:
        - major
        - minor
        - patch
        - custom
      version:
        description: 'Version of the release (only for custom release)'
        required: false
        type: string
      releaseNotes:
        description: 'Release notes'
        required: true
        type: string
      generateReleaseNotes:
        description: 'Auto generate release notes'
        required: false
        default: true
        type: boolean
      releaseDraft:
        description: 'Release draft'
        required: false
        default: false
        type: boolean
      preRelease:
        description: 'Pre-release'
        required: false
        default: false
        type: boolean
      targetCommitish:
        description: 'Target commitish'
        required: false
        default: 'main'
        type: string

jobs:
  release:
    runs-on: ubuntu-latest
    needs: merge
    steps:
    - name: Checkout
      uses: actions/checkout@v3
      with:
        fetch-depth: 0
    - name: Checkout Actions
      uses: actions/checkout@v3
      with:
        repository: Consuma/actions
        path: create-release
    - name: Release
      uses: ./create-release/release-management
      with:
        typeOfRelease: ${{ github.event.inputs.typeOfRelease }}
        version: ${{ github.event.inputs.version }}
        releaseNotes: ${{ github.event.inputs.releaseNotes }}
        generateReleaseNotes: ${{ github.event.inputs.generateReleaseNotes }}
        releaseDraft: ${{ github.event.inputs.releaseDraft }}
        preRelease: ${{ github.event.inputs.preRelease }}
        targetCommitish: ${{ github.event.inputs.targetCommitish }}
        githubToken: ${{ secrets.GITHUB_TOKEN }}
```

## Inputs

- `typeOfRelease` - Type of release (major, minor, patch, custom)
- `version` - Version of the release (only for custom release)
- `releaseNotes` - Release notes in a raw string
- `generateReleaseNotes` - Option to auto generate diff between the current and previous release
- `releaseDraft` - Draft release or not
- `preRelease` - Pre-release or not
- `targetCommitish` - Target commitish
- `githubToken` - Default GitHub token provided by GitHub Actions

## Contributing

Contributions are welcome! Feel free to open an issue or a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/Consuma/actions/blob/main/LICENSE)

## Contact

For more information, drop an email to us [here](mailto:contact@consuma.ai).