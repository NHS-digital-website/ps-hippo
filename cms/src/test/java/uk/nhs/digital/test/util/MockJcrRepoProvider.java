package uk.nhs.digital.test.util;

import static java.util.Collections.emptyMap;

import org.apache.jackrabbit.util.ISO8601;
import org.apache.sling.testing.mock.jcr.MockJcr;
import org.yaml.snakeyaml.Yaml;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.Map;
import javax.jcr.Node;
import javax.jcr.Repository;
import javax.jcr.Session;

public class MockJcrRepoProvider {

    public static Session repoFromYaml(final String fileClassPath) {

        Repository repository;
        Session session;
        try {
            repository = MockJcr.newRepository();
            session = repository.login();
        } catch (Exception e) {
            throw new RuntimeException("Failed to load JCR content from fixture file " + fileClassPath, e);
        }

        initJcrRepoFromYaml(session, fileClassPath);

        return session;
    }

    public static void initJcrRepoFromYaml(final Session session, final String fileClassPath) {

        try {
            Node rootNode = session.getRootNode();

            List<Map<String, Object>> nodes = parseYaml(fileClassPath);

            for (Map object : nodes) {
                NodeYaml node = new NodeYaml(
                    (String) object.get("path"),
                    (String) object.get("primaryType"),
                    (Map<String, Object>) object.getOrDefault("properties", emptyMap())
                );
                Node secondaryNode = rootNode.addNode(node.path, node.primaryType);
                for (Map.Entry<String, Object> entry : node.properties.entrySet()) {
                    if (entry.getValue() instanceof Boolean) {
                        secondaryNode.setProperty(entry.getKey(), (Boolean) entry.getValue());
                    } else if (entry.getValue() instanceof Date) {
                        Calendar myCal = new GregorianCalendar();
                        myCal.setTime((Date) entry.getValue());
                        secondaryNode.setProperty(entry.getKey(), ISO8601.format(myCal));
                    } else {
                        secondaryNode.setProperty(entry.getKey(), entry.getValue().toString());
                    }
                }
            }

            session.save();
        } catch (final Exception exception) {
            throw new RuntimeException("Failed to load JCR content from fixture file " + fileClassPath, exception);
        }
    }

    private static List<Map<String, Object>> parseYaml(final String fileClassPath) {

        final Yaml parser = new Yaml();
        try (final InputStream fixtureYamlFileInputStream =
                 MockJcrRepoProvider.class.getResourceAsStream(fileClassPath)) {

            if (fixtureYamlFileInputStream == null) {
                throw new RuntimeException("No file was available at " + fileClassPath);
            }

            return (List<Map<String, Object>>) parser.load(fixtureYamlFileInputStream);

        } catch (final Exception e) {
            throw new RuntimeException("Failed to parse the fixture file", e);
        }
    }

    private static class NodeYaml {
        private String path;
        private String primaryType;
        private Map<String, Object> properties;

        private NodeYaml(String path, String primaryType, Map<String, Object> properties) {
            this.path = path;
            this.primaryType = primaryType;
            this.properties = properties;
        }
    }
}
