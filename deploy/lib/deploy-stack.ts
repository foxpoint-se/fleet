import * as cdk from "aws-cdk-lib";
import * as fs from "fs";
import * as path from "path";
import { Construct } from "constructs";

// stolen from
// https://github.com/aws/aws-cdk/issues/19303

const iot = cdk.aws_iot;
export class UnusedStackForInspiration extends cdk.Stack {
  constructor(scope: Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);

    // To create IotThing
    const iotCoreThing = new iot.CfnThing(this, "iotCoreThing", {
      thingName: "iotCoreThing-iot-thing",
    });

    // create certificate
    const iotCoreThingCertificate2 = new iot.CfnCertificate(
      this,
      "IotCoreThingCertificate",
      {
        status: "ACTIVE",
        certificateSigningRequest:
          "arn:aws:acm-pca:::template/RootCACertificate/V1",
        // caCertificatePem: fs
        //   .readFileSync(`${__dirname}/../iot_certs/root-CA.crt`) // <---- this is th file I got from get started page.  i thought I can reuse it
        //   .toString(),
        // certificatePem: fs
        //   .readFileSync(`${__dirname}/../iot_certs/raspi.cert.pem`) // <---- this is th file I got from get started page.  i thought I can reuse it
        //   .toString(),
      }
    );

    const iotCoreThingCertificate = new iot.CfnCertificate(
      this,
      "IotCoreThingCertificate",
      {
        status: "ACTIVE",
        certificateSigningRequest: fs.readFileSync(
          path.resolve("cert/cert.csr"),
          "utf8"
        ),
      }
    );

    // create policy
    const iotPolicy = new iot.CfnPolicy(this, "Policy", {
      policyName: "Raspberry_Pi_Policy",
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

    // connect thing and certificate
    const policyPrincipalAttachment = new iot.CfnPolicyPrincipalAttachment(
      this,
      "PolicyPrincipalAttachment",
      {
        policyName: iotPolicy.policyName || "PolicyPrincipalAttachment",
        principal: iotCoreThingCertificate.attrArn,
      }
    );

    // connect policy and certificate
    const thingPrincipalAttachment = new iot.CfnThingPrincipalAttachment(
      this,
      "ThingPrincipalAttachment",
      {
        thingName: iotCoreThing.thingName || "ThingPrincipalAttachment",
        principal: iotCoreThingCertificate.attrArn,
      }
    );
  }
}
