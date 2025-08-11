// Script to convert Super.Human.Portal artifacts into a format for Genesis
// 
// USAGE:  groovy GenerateGenesisFiles.groovy <nsf-path> <files-path> <json-template-path>
// Parameters:
//  - nsf-path - the path to the exported NSF
//  - files-path - A directory with the files to be imported.  This is expected to be extracted from a GitHub release artifact
//  - json-template-path - the path to a the JSON template
// Output (local directory):
//  - genesis_attachments/* - a flat directory of attachments to include
//  - install.json - JSON that willl tell Genesis how to import the project


import java.nio.file.Path
import java.nio.file.Paths
import java.nio.file.Files
import groovy.json.JsonBuilder
import groovy.json.JsonOutput

USAGE = 'groovy GenerateGenesisFiles.groovy <nsf-path> <files-path> <json-template-path>'
if (args.length < 3) {
    println "Insufficient arguments"
    println "USAGE:  $USAGE"
    System.exit(1)
}
String nsfPath = args[0]
String filesPath = args[1]
String templatePath = args[2]

if (!nsfPath || !new File(nsfPath).exists()) {
    throw new Exception("Invalid path:  '$nsfPath'")
}
if (!filesPath || !new File(filesPath).exists() || !new File(filesPath).isDirectory()) {
    throw new Exception("Invalid path:  '$filesPath'")
}
if (!templatePath || !new File(templatePath).exists()) {
    throw new Exception("Invalid path:  '$templatePath'")
}

String nsfName = new File(nsfPath).getName()

// TODO:  support Windows  line separators. Note that this will need a pattern as well
String separator = '/'
String separatorPattern = '/'

// output
String attachmentsDir = 'genesis_attachments'
Files.createDirectories(Paths.get(attachmentsDir))
String installJSONFile = 'install.json'

// path defaults
String fromBase = '${baseurl}/0/${docid}/$FILE'
String toBase = '${directory}/domino/html/Super.Human.Portal/js-release'
String toDominoBase = '${directory}'


println "find '$filesPath' -type f"
def fileListProc = "find $filesPath -type f".execute()
fileListProc.waitFor()
def fileList = fileListProc.text

// initialize file list and add an entry for the databaes
def fileMap = []
fileMap << [ from: "$fromBase/$nsfName", to: "$toDominoBase/$nsfName" ]
Files.copy(Paths.get(nsfPath), Paths.get(attachmentsDir, nsfName))

fileList.eachLine { String line ->
    //String cleaned = line.replaceAll("^\\.$separatorPattern", '')
    String cleaned = line.replaceAll("^$filesPath$separatorPattern", '')
    String collapsedName = cleaned.replaceAll(separatorPattern, '_')
    //println "$cleaned > $collapsedName"
    if (cleaned.toLowerCase().endsWith('.ds_store')) {
        println ("Skipping '$cleaned'")
    }
    else {
        Files.copy(Paths.get(line), Paths.get(attachmentsDir, collapsedName))
        fileMap << [ from: "$fromBase/${collapsedName}", to: "$toBase/${cleaned}" ]
    }
}

JsonBuilder filesJSON = new JsonBuilder()
filesJSON fileMap, {curMap ->
    from curMap.from
    to curMap.to
    replace true
}
//println JsonOutput.prettyPrint(filesJSON.toString())

String json = new File(templatePath).text
json = json.replace('%filesJSON%', filesJSON.toString())
//println JsonOutput.prettyPrint(json)
new File(installJSONFile) << JsonOutput.prettyPrint(json)
