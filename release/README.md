# Instructions to Update Genesis superhumanportal Application

## Create Release and Royale Artifact

1. Create release using [these instructions](https://github.com/Moonshine-IDE/Super.Human.Portal/wiki/Super.Human.Portal-GitHub-Release-Instructions).
2.  Download the resulting zip and save it in your release directory.
3.  Unzip the zip.  You should see a js-releasees directory

## Create Database Artifact

This is currently done with Prominic servers and agents, so I am excluding the full names:
1. Import the agents to the official copy of the database
2. Update the configured version and run the agent to export a release copy of the databse
3. Copy `/tmp/SuperHumanPortal.nsf` to your release directory

## Generate the Genesis artifacts

From the release directory, run:

    groovy path/to/GenerateGenesisFiles.groovy SuperHumanPortal.nsf js-release path/to/install_template.json

This will generate:
- install.json - use this for the Genesis JSON script
- genesis_attachments/ - These are the files to attach to the Genesis application document


## Update the Genesis Document

1. Open the Genesis Directory database
2. In the `2. Package` view, open the `superhumanportal` document
3. Remove the Files, and replace them with the files from genesis_attachments
4. Update "Version (package)" with the new release version
5. Update JSON with the contents of install.json
6. Save the document


## Testing

1. From an existing Super.Human.Installer instance, run `sudo domino console` and run `tell Genesis install superhumanportal`.  Test the application to confirm it is correct
2. Create a new Super.Human.Installer instance, and test that the correct version of Super.Human.Portal is installed. 
