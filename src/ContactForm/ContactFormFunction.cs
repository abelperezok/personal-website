using System.Collections.Generic;
using System.Threading.Tasks;
using Amazon.Lambda.Core;
using Amazon.Lambda.APIGatewayEvents;
using Amazon.SimpleNotificationService;
using System;
using System.Net;
using System.Text;
using System.Text.Json;

// Assembly attribute to enable the Lambda function's JSON input to be converted into a .NET class.
[assembly: LambdaSerializer(typeof(Amazon.Lambda.Serialization.SystemTextJson.DefaultLambdaJsonSerializer))]

namespace ContactForm
{
    public class ContactFormFunction
    {
        private static IAmazonSimpleNotificationService _snsClient;

        public ContactFormFunction(IAmazonSimpleNotificationService snsClient)
        {
            _snsClient = snsClient;
        }

        public ContactFormFunction()
        {
            _snsClient = new AmazonSimpleNotificationServiceClient();
        }

        private string FormatMessage(ContactFormMessage msg)
        {
            var result = new StringBuilder();
            result.AppendLine($"Message from: {msg.Name} <{msg.Email}>");
            result.AppendLine($"--------------------------------------");
            result.AppendLine(msg.Message);
            result.AppendLine($"--------------------------------------");
            return result.ToString();
        }

        public async Task<APIGatewayProxyResponse> PostFunctionHandlerAsync(APIGatewayProxyRequest apigProxyEvent, ILambdaContext context)
        {
            var input = JsonSerializer.Deserialize<ContactFormMessage>(apigProxyEvent.Body);
            var topicArn = Environment.GetEnvironmentVariable("CONTACT_SNS_TOPIC");
            
            var msg = FormatMessage(input);
            var publishResponse = await _snsClient.PublishAsync(topicArn, msg, "Contact form message");

            return new APIGatewayProxyResponse
            {
                Body = JsonSerializer.Serialize(new { success = true }),
                StatusCode = (int)HttpStatusCode.OK,
                Headers = new Dictionary<string, string> { 
                    { "Content-Type", "application/json" },
                    { "Access-Control-Allow-Origin", "*" }
                }
            };
        }
    }
}
