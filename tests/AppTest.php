<?php
// tests/AppTest.php

use PHPUnit\Framework\TestCase;
use App\App;

class AppTest extends TestCase {
    public function testGetMessage() {
        $app = new App();
        $this->assertEquals("Congratulations on your PHP project", $app->getMessage());
    }
}
