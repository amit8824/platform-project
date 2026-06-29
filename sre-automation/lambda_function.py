import boto3

def lambda_handler(event, context):
    ec2 = boto3.client("ec2")
    result = ec2.describe_instances()
    count = 0

    for reservation in result["Reservations"]:

        for instance in reservation["Instances"]:

            print(
              instance["InstanceId"],
              instance["State"]["Name"]
            )

            count += 1


    return {

        "instances_checked": count
    }
