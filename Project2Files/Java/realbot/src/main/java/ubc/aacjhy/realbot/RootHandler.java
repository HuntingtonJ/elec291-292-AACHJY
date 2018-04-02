package ubc.aacjhy.realbot;

import com.sun.net.httpserver.Headers;
import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

import static ubc.aacjhy.realbot.main.port;

public class RootHandler implements HttpHandler {

    @Override
    public void handle(HttpExchange he) throws IOException {

        File file = new File("./client_src/index.html").getCanonicalFile();
        File file2 = new File("./client_src/client.js").getCanonicalFile();

        if (!file.isFile()) {
            String response = "404 (Not Found)\n";
            he.sendResponseHeaders(404, response.length());
            OutputStream os = he.getResponseBody();
            os.write(response.getBytes());
            os.close();
        } else {
            String mime = "text/html";

            Headers header = he.getResponseHeaders();
            header.set("Content-Type", mime);
            he.sendResponseHeaders(200, 0);

            OutputStream os = he.getResponseBody();
            FileInputStream fs = new FileInputStream(file);
            final byte[] buffer = new byte[0x10000];
            int count = 0;
            while ((count = fs.read(buffer)) >= 0) {
                os.write(buffer,0,count);
            }

            fs.close();
            os.close();
        }
    }
}
