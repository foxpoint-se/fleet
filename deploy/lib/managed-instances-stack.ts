import * as cdk from "aws-cdk-lib";
import { Construct } from "constructs";

export class ManagedInstancesStack extends cdk.Stack {
  constructor(scope: Construct, id: string, props: cdk.StackProps) {
    super(scope, id, props);

    const activationCode = new cdk.aws_secretsmanager.Secret(
      this,
      "SsmActivationCode",
      {
        description: "Code for when registering with SSM agent",
        secretName: "SsmActivationCode",
      }
    );

    const activationId = new cdk.aws_secretsmanager.Secret(
      this,
      "SsmActivationId",
      {
        description: "Id for when registering with SSM agent",
        secretName: "SsmActivationId",
      }
    );

    new cdk.CfnOutput(this, "ActivationCodeSecretInstruction", {
      value: `aws secretsmanager put-secret-value --region ${props.env?.region} --secret-id ${activationCode.secretName} --secret-string REDACTED`,
    });

    new cdk.CfnOutput(this, "ActivationIdSecretInstruction", {
      value: `aws secretsmanager put-secret-value --region ${props.env?.region} --secret-id ${activationId.secretName} --secret-string REDACTED`,
    });
  }
}
