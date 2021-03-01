import groovy.io.FileType
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.yaml.snakeyaml.DumperOptions
import org.yaml.snakeyaml.Yaml

import static java.lang.Character.isDigit
import static java.lang.Integer.parseInt

class YamlFormatter extends Script {

    // Don't remove the UUID for corporate-website, it's referenced in the facet configuration
    // Same for ci-hub, since referenced for page links
    static final Set keepUuidFiles =
        ["corporate-website.yaml",
         "ccg-outcomes.yaml",
         "compendium-indicators.yaml",
         "nhs-outcomes-framework.yaml",
         "patient-online-management-information-pomi.yaml",
         "social-care.yaml",
         "summary-hospital-level-mortality-indicator-shmi.yaml",
         "content.yaml",
         "nihub.yaml",
         "nihublink.yaml",
         "acceptance-tests-images.yaml",
         "events.yaml",
         "news.yaml",
         "news-and-events-hub.yaml",
         "news-and-events.yaml",
         "cyber-alerts.yaml"]

    // We don't want to change the order of the children of '/_default_' tags
    // as these are used below '/editor:templates:' tags and determine the order
    // of the components in the CMS.
    static final Set ignoreSortNodes =
        ["/_default_",
         "/content/documents/corporate-website/publication-system/acceptance-tests/sectioned-publication"]

    def run() {
        // Options for how the file is written out
        DumperOptions options = new DumperOptions()
        options.setDefaultFlowStyle(DumperOptions.FlowStyle.BLOCK)
        options.setExplicitStart(true) // This puts '---' at the start of the document
        Yaml parser = new Yaml(options)

        Logger log = LoggerFactory.getLogger(YamlFormatter.class)
        log.info("Starting to format yaml files")

        // Go through all yaml files in all the repository-data subfolders and format them
        File rootDir = new File("${project.parent.parent.basedir}/repository-data")
        rootDir.eachFileRecurse(FileType.DIRECTORIES) {
            dir ->
                if (dir.getPath().contains('node_modules')) {
                    return;
                }
                dir.eachFileMatch(FileType.FILES, ~/.*.yaml/) { file ->
                    String text = file.getText()

                    LinkedHashMap map
                    try {
                        map = parser.load(text)
                    } catch (Exception parsingException) {
                        log.error("Failed to parse file: $file", parsingException)
                        throw parsingException
                    }

                    boolean removeUuid = !keepUuidFiles.contains(file.getName())
                    map = format(map, null, removeUuid)

                    // Write out the formatted yaml
                    parser.dump(map, new FileWriter(file))
                }
        }

        log.info("Finished formatting yaml files")
    }

    private LinkedHashMap format(LinkedHashMap map, String nodeName, boolean removeUuid) {
        // Sort alphabetically so the order is deterministic
        boolean sortNode = !ignoreSortNodes.contains(nodeName)
        if (sortNode) {
            map = map.sort(AlphaNumericComparator.COMPARATOR) as LinkedHashMap
        }

        // Remove the uuid so hippo can generate one on startup
        if (removeUuid) {
            map.remove("jcr:uuid")
        }

        // Apply to all the sub-maps as well
        for (String key : map.keySet()) {
            def value = map.get(key)
            if (value instanceof LinkedHashMap) {
                map.put(key, format(value, key, removeUuid))
            }
        }

        return map
    }

    /**
     * For comparing paths so that the order of sub elements goes [9] -> [10] -> [11]
     */
    static class AlphaNumericComparator implements Comparator<String> {
        static final AlphaNumericComparator COMPARATOR = new AlphaNumericComparator();

        int compare(String s1, String s2) {
            StringBuilder s1Part = new StringBuilder();
            StringBuilder s2Part = new StringBuilder();

            // + 1 so we compare the numbers at the very end of the string
            int max = Math.min(s1.length(), s2.length()) + 1;

            for (int i = 0; i < max; i++) {
                char c1 = getChar(s1, i);
                char c2 = getChar(s2, i);

                boolean c1Digit = isDigit(c1);
                boolean c2Digit = isDigit(c2);

                if (c1Digit && c2Digit) {
                    s1Part.append(c1);
                    s2Part.append(c2);
                    continue;
                } else if (s1Part.length() > 0) {
                    if (c1Digit) {
                        // c1 is a number and c2 isn't
                        return 1;
                    } else if (c2Digit) {
                        // c2 is a number and c1 isn't
                        return -1;
                    } else {
                        int diff = parseInt(s1Part.toString()) - parseInt(s2Part.toString());
                        if (diff != 0) {
                            return diff;
                        }
                        s1Part.setLength(0);
                        s2Part.setLength(0);
                    }
                }

                if (c2 != c1) {
                    return c1 - c2;
                }
            }

            // strings are the same up to the length of the shorter string
            return s2.length() - s1.length();
        }

        private static char getChar(String string, int index) {
            return index < string.length() ? string.charAt(index) : 0;
        }
    }

}
