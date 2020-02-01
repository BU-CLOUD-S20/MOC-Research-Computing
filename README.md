** **
# Create a Kubernetes based on-demand research computing environment in MOC

## 1. Vision and Goals Of The Project:

The cloud is full of unlimited computing power and storage, but managing it is not easy. Sid is a research tool that allows researchers to launch scientific computing environments, such as Jupyter Notebook and R Studio, on the cloud effortlessly. 

The architecture of Sid can be separated into 3 large components:
 - front-end, specficially a web interface
 - middleware, specifically API gateway, database for user information, scheduling services and communication modules to talk to back-end services
 - back-end, specfically a container infrastructure where kubernetes instances run on VMs, maintained by a cloud-operating system.

Currently, Sid's backend container infrastructure is powered by Amazon Elastic Kubernetes Service (EKS), which runs on AWS. The final goal of this project (by the end of this semester) is to *run Sid's backend container infrastructure on MOC via openstack.* 

In other words, we will replicate the functionalities of Amazon Elastic Kubernetes Service by developing a cloud operating system using openstack. The cloud operating system will deploy and manage new VMs on MOC. These VMs will run Kubernetes to host scientific computing environment as requested by the user (via the front-end interface).

## 2. Users/Personas Of The Project:

This section describes the principal user roles of the project together with the key characteristics of these roles. This information will inform the design and the user scenarios. A complete set of roles helps in ensuring that high-level requirements can be identified in the product backlog.

Again, the description should be specific enough that you can determine whether user A, performing action B, is a member of the set of users the project is designed for.

** **

## 3.   Scope and Features Of The Project:

The Scope places a boundary around the solution by detailing the range of features and functions of the project. This section helps to clarify the solution scope and can explicitly state what will not be delivered as well.

It should be specific enough that you can determine that e.g. feature A is in-scope, while feature B is out-of-scope.

** **

## 4. Solution Concept

This section provides a high-level outline of the solution.

Global Architectural Structure Of the Project:

This section provides a high-level architecture or a conceptual diagram showing the scope of the solution. If wireframes or visuals have already been done, this section could also be used to show how the intended solution will look. This section also provides a walkthrough explanation of the architectural structure.



Design Implications and Discussion:

This section discusses the implications and reasons of the design decisions made during the global architecture design.

## 5. Acceptance criteria

This section discusses the minimum acceptance criteria at the end of the project and stretch goals.

## 6.  Release Planning:

Release planning section describes how the project will deliver incremental sets of features and functions in a series of releases to completion. Identification of user stories associated with iterations that will ease/guide sprint planning sessions is encouraged. Higher level details for the first iteration is expected.

** **

## General comments

Remember that you can always add features at the end of the semester, but you can't go back in time and gain back time you spent on features that you couldn't complete.

** **

For more help on markdown, see
https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet

In particular, you can add images like this (clone the repository to see details):

![alt text](https://github.com/BU-NU-CLOUD-SP18/sample-project/raw/master/cloud.png "Hover text")
