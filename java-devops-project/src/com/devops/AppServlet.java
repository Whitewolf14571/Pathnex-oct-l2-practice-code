package com.devops;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class AppServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");

        PrintWriter out = response.getWriter();

        out.println("<html>");
        out.println("<head><title>CI/CD Demo</title></head>");
        out.println("<body>");
        out.println("<h1>CI/CD Pipeline is working!</h1>");
        out.println("<p>Application deployed on Tomcat.</p>");
        out.println("</body>");
        out.println("</html>");
    }
}
