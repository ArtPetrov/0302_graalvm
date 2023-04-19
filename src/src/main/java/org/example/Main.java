package org.example;

import org.example.server.Server;

import java.io.IOException;

public class Main {
  public static void main(String[] args) throws IOException {
    final Server server = new Server();
    final String port = System.getProperty("port");
    server.serve(Integer.parseInt(port));
  }
}
