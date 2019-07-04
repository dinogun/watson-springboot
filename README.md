# Java, Containers and Kubernetes

Not so long ago Java did not gel well with Containers leading to applications performing suboptimally or worse, getting terminated in kubernetes. Since then however, there have been a number of changes to the JVM, including making it container aware, new flags that help the heap to grow and shrink along with the container memory restrictions, better defaults and in general a much better user experience. Together with the Modularity feature, that was introduced from Java 9 onwards, Java pplications can now be small and nimble, agile, boast fast start up times, have a very small memory footprint all the while continuing to provide the best possible thoughput! This tutorial looks at each of the above mentioned features in a lot more detail and what the users need to do to get the most of running their Java applications in a Kubernetes based Cloud.

Enjoy and welcome to the new world of Java in the Cloud !

## Eclipse OpenJ9

[Eclipse OpenJ9](https://www.eclipse.org/openj9/) is a high performance, scalable, Java virtual machine (JVM) implementation that has a proven track record of running Java applications in production environments. Contributed to the Eclipse project by IBM, the OpenJ9 JVM underpins the IBM SDK, Java Technology Edition product that is a core component of many IBM Enterprise software products. Continued development of OpenJ9 at the Eclipse foundation ensures wider collaboration, fresh innovation, and the opportunity to influence the development of OpenJ9 for the next generation of Java applications. OpenJDK binaries that include Eclipse OpenJ9 are available through AdoptOpenJDK.

We will be using OpenJ9 for the tutorial below, however the repo has HotSpot examples as well.

## What is AdoptOpenJDK ?

[AdoptOpenJDK](https://adoptopenjdk.net/) is a communiity of Java™ user group members, Java developers and vendors who are advocates of OpenJDK, the open source project which forms the basis of the Java programming language and platform. AdoptOpenJDK provides prebuilt OpenJDK binaries from a fully open source set of build scripts and infrastructure. AdoptOpenJDK builds and tests binaries for different source code streams based upon OpenJDK. Our binaries undergo extensive testing, and the Releases have passed all the available OpenJDK test suites and our additional tests (donated by the community), ensuring the best quality binary available.

## Tutorial


### Sample application

We use a Springboot application that uses two Watson services:

Visual Recognition : It detects the human faces in the image and determines their name, gender, maximum and minimum age.
Text to Speech: It converts the given text to audio. You also have the option to download the audio file.

See this [link](https://github.com/ibmruntimes/java.bluemix.demos/tree/master/samples) for more info on how to run this application.

Now let us look at five steps to cloud proof this app.

### Optimize Size

Traditionally Java applications have been known to be bulky monoliths, that usually take up more than a GB in size especially when packaged with a App server and the JRE. Why is this bad ? In the cloud, there is no such thing as a dedicated resoure for your applicatio. The apps get deployed on whichever node happens to be free at that point and there is no guarantee the node will be local. It can even be on the public cloud which is hosted in a datacenter halfway across the world. Fat docker images do not make it easy to be deployed and provisioned in these scenarios. This is why it is very important to reduce the disk footprint of the docker images. Reducing non essential packages/modules etc, makes the images more secure by reducing the attack surface and make it easier to maintain.

The JDK is clearly aware of this fact and it is now available in slim variants which remove a number of packages/jars/tools that are not usually needed when being deployed to the cloud. There are variants available built on Alpine Linux, which is a stripped down version of Linux that is based on musl libc and Busybox, resulting in a Docker image size of approximately 5 MB.

Java 9 helped modularize the JVM itself. This now means that using the jlink tool, you can now package only the specific modules that you need and create a custom JRE that is specific to your application.

The table below lists the docker image sizes of the application built on top of different OpenJ9 base images. See the corresponding [dockerfiles](https://github.com/dinogun/watson-springboot/tree/master/docker) to understand how they were built. Note that the jlinked Java 11 based image is 68% smaller than the regular Java 8 based image and 74% smaller than the regular Java 11 based image !

| App | Size |
| --- | ---- |
| watson-springboot-openj9-v8 | 232MB |
| watson-springboot-openj9-v8.slim | 117MB |
| watson-springboot-openj9-v11 | 228MB |
| watson-springboot-openj9-v11.jlink | 86MB |

### Optimize Startup

| App | Size | Startup Time |
| --- | ---- |:------------:|
| watson-springboot-openj9-v8 | 232MB | 4 secs |
| watson-springboot-openj9-v8.slim | 117MB | 4 secs |
| watson-springboot-openj9-v11 | 228MB | 4 secs |
| watson-springboot-openj9-v11.jlink | 86MB | 4 secs |
| watson-springboot-openj9-v11.jlink.scc | 118MB | 2 secs |

### Optimize Runtime

### Optimize Idletime

### Optimize Debug
