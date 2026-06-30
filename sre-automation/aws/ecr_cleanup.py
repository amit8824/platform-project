import boto3

ecr = boto3.client("ecr", region_name="ap-south-1")

images = ecr.list_images(repositoryName="platform-api")

for image in images["imageIds"]:

    print(image)
