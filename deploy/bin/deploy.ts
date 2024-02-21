#!/usr/bin/env node
import "source-map-support/register";
import * as cdk from "aws-cdk-lib";
import { FleetStack } from "../lib/fleet-stack";
import { ManagedInstancesStack } from "../lib/managed-instances-stack";

const app = new cdk.App();

new FleetStack(app, "FleetStack", {
  env: { account: "485563272586", region: "eu-west-1" },
});

new ManagedInstancesStack(app, "ManagedInstancesStack", {
  env: { account: "485563272586", region: "eu-west-1" },
});
