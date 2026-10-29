package com.devops;

import org.junit.Test;
import static org.junit.Assert.*;

public class AppTest {

    @Test
    public void testMessage() {
        assertEquals(
            "CI/CD Pipeline is working!",
            App.message()
        );
    }
}
