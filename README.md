# RestService - A light REST service framework for iOS projects

[![Build Status](https://travis-ci.com/ricardorauber/RestService.svg?branch=master)](http://travis-ci.com/)
[![CocoaPods Version](https://img.shields.io/cocoapods/v/RestService.svg?style=flat)](http://cocoadocs.org/docsets/RestService)
[![License](https://img.shields.io/cocoapods/l/RestService.svg?style=flat)](http://cocoadocs.org/docsets/RestService)
[![Platform](https://img.shields.io/cocoapods/p/RestService.svg?style=flat)](http://cocoadocs.org/docsets/RestService)

## TL; DR

`RestService` is a light REST service based on the `URLRequest` with some vanilla on top. Check this out:

```swift
let service = RestService(host: "api.github.com")

let task = service.json(
    method: .get,
    path: "/users/ricardorauber/repos",
    interceptor: nil,
    responseType: [Repository].self) { response in
        switch response {
        case .success(let repositories):
            print("cool!", repositories)
        case .failure:
            print("oh no!")
        }
}
```

## REST Service

Hey there, thanks for coming! If you got here is because you are looking for something to help implementing the HTTP requests for your app, right? 
That's exactly what this framework does and I hope it fits in your project smoothly. You might be wondering why another service and what are the advantages over great frameworks like Alamofire, right?
Well, indeed there are many solutions out there and they are great for sure. The only think is that they are so good that they have too much possibilities and I wanted to build something really simple, secure and easy to use.
Let me show you how it works and you will decide if it's a good solution for you.

## Setup

#### CocoaPods

If you are using CocoaPods, add this to your Podfile and run `pod install`.

```Ruby
target 'Your target name' do
    pod 'RestService', '~> 2.2'
end
```

#### Manual Installation

If you want to add it manually to your project, without a package manager, just copy all files from the `Classes` folder to your project.

## Usage

#### Creating the Service

To create an instance of the service, you only need to import the framework and instantiate the `RestService` with your host. Let's say that your host is `https://server.com/`:

```swift
import RestService
let service = RestService(host: "server.com")
```

It will create a service ready to be used with an `https` scheme. But let's say you need to use something else, you can add more information for the service:

```swift
import RestService
let service = RestService(
    session: URLSession.shared,
    decoder: JSONDecoder(),
    scheme: .http, 
    host: "localhost", 
    port: 3000,
    basePath: "/api"
)
```

With that, it will create a service for `http://localhost:3000/api`.

Note that all of those properties can be changed later. 

The `basePath` parameter set's the base path for all requests, so if you make a request for a `/users` path, for instance, it will send it to `http://localhost:3000/api/users`.

#### Making a simple JSON request

Now that you have your service created, it's time to make some requests. Let's start with a very simple `GET` request on the `api/users` endpoint:

```swift
service.json(
    method: .get,
    path: "/api/users",
    interceptor: nil) { response in
    
    switch response {
    case .success:
        print("success!")
    case .failure:
        print("failure")
    }
}
```

See that? It is very simple!

#### Making a JSON request with parameters

Now let's make a request with parameters, but first let's clarify something about these parameters. When you make `GET`, `HEAD` and `DELETE` requests, you send parameters as query strings, but for all other methods, you send parameters in the request body. With that, the `RestService` will set the right properties depending on the method you have selected for that request.

Another thing here is to decide if you want to use simple dictionaries or `Encodable` objects as the parameters. I personally prefer `Encodable` objects, because the compiler will complain about a typo in your parameter names, for instance, and it will be better to code the API logic.

So, let's make a `GET` request with a dictionary for parameters:

```swift
let parameters: [String: Any] = [
    "username": "john",
    "limit": 10,
    "offset": 0
]

service.json(
    method: .get,
    path: "/api/users",
    parameters: parameters,
    interceptor: nil) { response in
    
    switch response {
    case .success:
        print("success!")
    case .failure:
        print("failure")
    }
}
```

What just happened? Well, it did create a request for this URL without a body: `https://server.com/api/users?username=john&limit=10&offset=0`

What about `POST` requests? Let's see it in action using a `Encodable` object!

```swift
struct CreateUserRequest: Codable {
    let username: String
    let password: String
}

let parameters = CreateUserRequest(username: "john", password: "safepassword")

service.json(
    method: .post,
    path: "/api/users",
    parameters: parameters,
    interceptor: nil) { response in
    
    switch response {
    case .success:
        print("success!")
    case .failure:
        print("failure")
    }
}
```

With that, it has created a `POST` request for `https://server.com/api/users` with this `JSON` body:

```json
{
    "username": "john",
    "password": "safepassword"
}
```

Cool, right?

#### Making a FORM/DATA request with parameters

If you need to make a request with a `form/data` format, you can easily send it with some `FormDataParameters`. It is possible to create a `FileFormDataParameter` or a `TextFormDataParameter`.

So, let's make a `POST` request with some parameters:

```swift
let parameters: [FormDataParameter] = [
    TextFormDataParameter(name: "id", value: "10"),
    TextFormDataParameter(name: "email", value: "john@server.com"),
    FileFormDataParameter(name: "text", filename: "text.txt", contentType: "text/plain", data: textData),
    FileFormDataParameter(name: "image", filename: "thumb.png", contentType: "image/png", data: imageData)
]

service.formData(
    method: .post,
    path: "/api/userdata",
    parameters: parameters,
    interceptor: nil) { response in
    
    switch response {
    case .success:
        print("success!")
    case .failure:
        print("failure")
    }
}
```

#### Making a simple request with a Data body

Ok, you are not using `JSON` or `FORM/DATA`, but you still want to send a request using `RestService`? Sure, that's very simple, just need to send the body as `Data`:

```swift
service.request(
    method: .post,
    path: "/api/upload",
    body: body,
    interceptor: nil) { response in
    
    switch response {
    case .success:
        print("success!")
    case .failure:
        print("failure")
    }
}
```

#### Making requests with an interceptor

Interceptors are a great way to change something on a request just before sending it to the server. That's a really good opportunity to add some headers like an authentication token, for instance. Let's see it in action!

```swift
struct TokenInterceptor: RequestInterceptor {
    func adapt(request: URLRequest) -> URLRequest {
        var request = request
        request.addValue("Bearer gahsjdGJSgdsajagA", forHTTPHeaderField: "Authorization")
        return request
    }
}

let interceptor = TokenInterceptor()

service.json(
    method: .get,
    path: "/api/me",
    interceptor: interceptor) { response in
    
    switch response {
    case .success:
        print("success!")
    case .failure:
        print("failure")
    }
}
```

This will add that token to the request just before the execution. Interceptors can be reused and they are great to add all those required stuff by the server.

If you need to add more than one interceptor, you can use the `RestInterceptorGroup`:

```swift
struct APIKeyInterceptor: RequestInterceptor {
    func adapt(request: URLRequest) -> URLRequest {
        var request = request
        request.addValue("12345", forHTTPHeaderField: "X-API-KEY")
        return request
    }
}
    
struct TokenInterceptor: RequestInterceptor {
    func adapt(request: URLRequest) -> URLRequest {
        var request = request
        request.addValue("Bearer gahsjdGJSgdsajagA", forHTTPHeaderField: "Authorization")
        return request
    }
}
    
let interceptor = GroupInterceptor(interceptors: [
    APIKeyInterceptor(),
    TokenInterceptor()
])

service.json(
    method: .get,
    path: "/api/me",
    interceptor: interceptor) { response in
    
    switch response {
    case .success:
        print("success!")
    case .failure:
        print("failure")
    }
}
```

### Dealing with the response from the server

One of the things that many people have issues is with the response from the server. Casting values, serializing, decoding... the possibilities are unlimited. What I tried to achieve with this framework was to have a nice response in the way you need the data.

There are 4 possibilities of response:

#### Without Body

If you just need to send a request and you are not expecting any object as a response, then you just need to make the call as we saw before:

```swift
service.json(
    method: .get,
    path: "/api/me",
    interceptor: nil) { response in
    
    switch response {
    case .success:
        print("success!")
    case .failure:
        print("failure")
    }
}
```

#### With a Response Type

Now let's say you need to convert the response body into a `Codable` object when the request has succeeded:

```swift
struct Person: Codable {
    let id: Int
    let name: String
}

service.json(
    method: .get,
    path: "/api/me",
    interceptor: nil,
    responseType: Person.self) { response in
    
    switch response {
    case .success(let person):
        print("success!", person)
    case .failure:
        print("failure")
    }
}
```

#### With a Custom Error from the server

If your web service has a custom way to reply with an error, let's say, a json object with the error details, you can use another parameter to get the response decoded to a `Codable` object like this:

```swift
struct ServerError: Codable {
    let code: Int
    let message: String
}

service.json(
    method: .get,
    path: "/api/me",
    interceptor: nil,
    customError: ServerError.self) { response in
    
    switch response {
    case .success:
        print("success!")
    case .customError(let error):
        print("server error", error)
    case .failure:
        print("failure")
    }
}
```

#### All Inclusive: Response Type + Custom Error from the server

Finally, you can have everything together, the successful response type, the custom error from the server and the generic failure:

```swift
struct Person: Codable {
    let id: Int
    let name: String
}
    
struct ServerError: Codable {
    let code: Int
    let message: String
}

service.json(
    method: .get,
    path: "/api/me",
    interceptor: nil,
    responseType: Person.self,
    customError: ServerError.self) { response in
    
    switch response {
    case .success(let person):
        print("success!", person)
    case .customError(let error):
        print("server error", error)
    case .failure:
        print("failure")
    }
}
```

### Handling the Task's Progress

A cool thing is that with `RestService` you can handle the progress of any kind of task (not just JSON), so you could update the UI, for instance:

```swift
service.json(
    method: .get,
    path: "/api/me",
    interceptor: nil,
    progress: { value in
        print("progress:", value)
    },
    completion: { response in
    
        switch response {
        case .success:
            print("success!")
        case .failure:
            print("failure")
        }
    }
)
```

### Debug / Log

Last but not least, as developers we often need to debug some requests and usually it needs some effort to make it nice, so I have done something cool to make your life much easier:

```swift
let service = RestService(debug: true, host: "api.github.com")
```

Just by adding the `debug` parameter when creating the service and setting it to `true`, you will see all requests being loggged in the Xcode's Console. Nice right? But that's not all, you could set the debug for a single request:

```swift
service.json(
    debug: true,
    method: .get,
    path: "/api/me",
    interceptor: nil,
    completion: { response in
    
        switch response {
        case .success:
            print("success!")
        case .failure:
            print("failure")
        }
    }
)
```

And how does it look like? Here is a little sample:

```
==============================================
 ⚪️ REQUEST: https://api.github.com/users/ricardorauber/repos 

> Headers:
[
    "Content-Type": "application/json; charset=utf-8"
] 

> Body:
nil 

 🟢 RESPONSE: 200 

> Headers:
[
    "referrer-policy": "origin-when-cross-origin, strict-origin-when-cross-origin",
    "x-github-media-type": "github.v3; format=json",
    "Status": "200 OK",
    ...
]

> Body:
[{"id":253579430,"node_id":"MDEwOlJlcG9zaXRvcnkyNTM1Nzk0MzA="}]

------------------------------
```

## Thanks 👍

The creation of this framework was possible thanks to these awesome people:

* Gray Company: [https://www.graycompany.com.br/](https://www.graycompany.com.br/)
* Swift by Sundell: [https://www.swiftbysundell.com/](https://www.swiftbysundell.com/)
* Hacking with Swift: [https://www.hackingwithswift.com/](https://www.hackingwithswift.com/)
* Ricardo Rauber: [http://ricardorauber.com/](http://ricardorauber.com/)

## Feedback is welcome

If you notice any issue, got stuck or just want to chat feel free to create an issue. We will be happy to help you.

## License

RestService is released under the [MIT License](LICENSE).
