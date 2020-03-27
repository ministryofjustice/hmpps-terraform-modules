var https = require('https');
var util = require('util');

exports.handler = function(event, context) {
    console.log(JSON.stringify(event, null, 2));


        const environment = process.env.ENVIRONMENT_TYPE;
        var heading = "EC2 Instance Auto-Stop Notification";
        var bodytext = "Please be advised EC2 Instances are scheduled to stop in approximately 60 mins.";
        var channel="delius_infra_ops";
        var url_path = "/services/T02DYEB3A/BS16X2JGY/r9e1CJYez7BDmwyliIl7WzLf";
        var icon_emoji=":sign-warning:";



 //environment	service	    tier	metric	severity	resolvergroup(s)

            console.log("Slack channel: " + channel);

               var postData = {
                       "channel": "# " + channel,
                       "username": "AWS SNS via Lambda :: EC2 Auto-stop notification",
                       "text": "**************************************************************************************************"
                       + "\nInfo: "  + heading
                       + "\nDetails: "  + bodytext
                       + "\nEnvironment: "  + environment

                       ,
                       "icon_emoji": icon_emoji,
                       "link_names": "1"
                   };

    var options = {
        method: 'POST',
        hostname: 'hooks.slack.com',
        port: 443,
        path: url_path
    };

    var req = https.request(options, function(res) {
      res.setEncoding('utf8');
      res.on('data', function (chunk) {
        context.done(null);
      });
    });

    req.on('error', function(e) {
      console.log('problem with request: ' + e.message);
    });

    req.write(util.format("%j", postData));
    req.end();
};
