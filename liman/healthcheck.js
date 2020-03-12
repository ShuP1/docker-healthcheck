var http = require("http");

var options = {
    host: "localhost",
    port: "5000",
    path: "/login",
    timeout: 2000
};

var request = http.request(options, (res) => {
    if (res.statusCode == 200) {
        process.exit(0);
    }
    else {
        console.log(`STATUS: ${res.statusCode}`);
        process.exit(1);
    }
});

request.on('error', function (err) {
    console.log('ERROR', err);
    process.exit(1);
});

request.end();