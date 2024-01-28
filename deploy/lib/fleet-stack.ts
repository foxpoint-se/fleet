import * as cdk from "aws-cdk-lib";
import { Construct } from "constructs";

const iot = cdk.aws_iot;
export class FleetStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    const iotPolicy = new iot.CfnPolicy(this, "Policy", {
      policyName: "IotFullAccessPolicy",
      policyDocument: {
        Version: "2012-10-17",
        Statement: [
          {
            Effect: "Allow",
            Action: ["iot:*"],
            Resource: ["*"],
          },
        ],
      },
    });
  }
}
