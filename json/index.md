# ADTs and JSON Decoding

By the end of this chapter you should know:

    - How and why we send and receive data
        - JSON as the file format
    - Encoding and Decoding - focus on the decoding part 
    - Json file -> Json ADT 
    - What Algebraic Data Types?
        Sum Types & Products Types
    - How to use them for Data Modelling 
    - Reading the data from a file
    - Building up the different decoders for each type
        - state machine
        - pattern matching
    - Putting it together 
    - Specific use case

## Sending and receiving data 

Something you as a software engineer will almost certainly encounter is sending and receiving of data. This can be when you're receiving HTTP requests from a front end web application, passing messages between different services or applications or for client-server communication. 

The Json file format is a commonly used standard for interchanging data between systems, where you can encode and decode it into the relevant data representation.

In order to receive information, you will need to take the Json and unpack it into a representation your system understands. We can do this by first defining a model of the Json structure, then build up a decoder from all the composition parts of our Json model. At the end we'll have a deocder that takes the .json file and gives us our data represented in our data model. 

First, how would we represent this data model. A common pattern used for modelling data in FP is Algebraic Data Types (ADTs).


## Algebraic Data Types 

Let's start with Algebraic Data Types or ADTs. 

These are a pattern of modelling data in code. They are formed of the combination of two types: Sums and Products. 

### Sum Types

Sum types are pieces of data where there is an 'or' relationship between variants.

Say we want to model different `Subscription` types that a user could have for a service. We can model this type in the following way: 
```roc
Subscription : [
    Free, 
    Premium { endDate: Str }
]  
```
Subscription can be of either type `Free` or `Premium`, these two types are known as the variants of `Subscription`. Notice, `Premium` also contains a field called `endDate`, describing the date on which this subscription is valid till. This is an example of associating a payload with a Sum type variant in Roc. Sum types are known as enum or union types in other languages. 


### Product Types

Product types are used for when we're modelling data that is made up of smaller pieces of information. Product types represent data where you have multiple pieces of information which have an 'and' relationship between them. For example, say we want represent a `User` which has a `name` and an `age`, we would represent this as:
```roc
User : {
            name: Str, 
            age: I64,
        }
```

This is called a record or a struct in other languages.

Now, product types can also contain Sum types. Let's see this in action with our User example. A User could also contain information on what kind of `subscription` they have. 

We would modify `User` to contain a `subscription` field of type `Subscription` which we modelled earlier: 
```roc
User : {
            name: Str, 
            age: I64,
            subscription: Subscription
        }
```

You can use these types in combination with each other to best model your data.

## Reading the data from file
Might need to introduce how you use packages from other people in Roc

What are we going to support decoding?

i64, u64, bool, string, list, record
## Decoders
- Build up each block of the decoder
- Putting it all together 

## Use case
Make it concrete, how would you write a decoder from Json -> `A`. `A` being some ADT e.g. `User` as described above. 
