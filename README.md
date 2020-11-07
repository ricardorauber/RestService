# RestService - A light REST service framework for iOS projects

[![Build Status](https://travis-ci.com/ricardorauber/RestService.svg?branch=master)](http://travis-ci.com/)
[![CocoaPods Version](https://img.shields.io/cocoapods/v/RestService.svg?style=flat)](http://cocoadocs.org/docsets/RestService)
[![License](https://img.shields.io/cocoapods/l/RestService.svg?style=flat)](http://cocoadocs.org/docsets/RestService)
[![Platform](https://img.shields.io/cocoapods/p/RestService.svg?style=flat)](http://cocoadocs.org/docsets/RestService)

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
    pod 'RestService', '~> 2.0'
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
let service = RestService(session: URLSession.shared, scheme: .http, host: "localhost", port: 3000)
```

With that, it will create a service for `http://localhost:3000/`.

#### Making a simple JSON request

Now that you have you service crated, it's time to make some requests. Let's start with a very simple `GET` request on the `api/users` endpoint:

```swift
service.json(
    method: .get,
    path: "/api/users",
    interceptor: nil) { response in
        print(response.stringValue())
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
        print(response.stringValue())
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
        print(response.stringValue())
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

If you need to make a request with a `form/data` format, you can easily send it with some `FormDataParameter`s. It is possible to create a `FileFormDataParameter` or a `TextFormDataParameter`.

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
        print(response.stringValue())
}
```

#### Making requests with an interceptor

Interceptors are a great way to change something on a request just before sending it to the server. That's a really good opportunity to add some headers like an authentication token, for instance. Let's see it in action!

```swift
struct TokenInterceptor: RestRequestInterceptor {
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
        print(response.stringValue())
}
```

This will add that token to the request just before the execution. Interceptors can be reused and they are great to add all those required stuff by the server.

If you need to add more than one interceptor, you can use the `RestInterceptorGroup`:

```swift
let interceptor = RestInterceptorGroup(interceptors: [
    APIKeyInterceptor(),
    TokenInterceptor()
])

service.json(
    method: .get,
    path: "/api/me",
    interceptor: interceptor) { response in
        print(response.stringValue())
}
```

### Dealing with the response from the server

One of the things that many people have issues is with the reponse from the server. Casting values, serializing, decoding... the possibilities are unlimited. What I tried to achieve with this framework was to have a nice response object that could provide us everything we want during the development (debugging) and release.

The result is the `RestResponse` object. It has only the 3 properties that `URLResponse` gives us, the the original `URLRequest` and some nice computed properties and methods to handle the data.

#### Status Code

You can easily see the status code of the response with this computed property. It will return `-1` if there was some error in the response.

```swift
service.json(
    method: .get,
    path: "/api/me",
    interceptor: interceptor) { response in
        if 200..<300 ~= response.statusCode {
            print("cool!")
        } else {
            print("oops!")
        }
}
```

#### Headers

If you need to get some information from the response's headers, you can easily get it by acessing the property:

```swift
service.json(
    method: .get,
    path: "/api/me",
    interceptor: interceptor) { response in
        print(response.headers["Token"])
}
```

#### String Value

When you receive a response from the server, it comes with a `Data?` body. If you want to convert it to a string value, just need to use the method and optionally giving a string encoder:

```swift
service.json(
    method: .get,
    path: "/api/me",
    interceptor: interceptor) { response in
        print(response.stringValue())
        print(response.stringValue(encoding: .Latin1))
}
```

#### Int Value

Some responses comes with a simple integer value, so you can easily get it:

```swift
service.json(
    method: .get,
    path: "/api/users/count",
    interceptor: interceptor) { response in
        print(response.intValue())
}
```

#### Double Value

You might also want to get a double value from the response:

```swift
service.json(
    method: .get,
    path: "/api/fees/default",
    interceptor: interceptor) { response in
        print(response.doubleValue())
}
```

#### Dictionary Value

If you want to get a dictionary from the response, there is a method for that:

```swift
service.json(
    method: .get,
    path: "/api/me",
    interceptor: interceptor) { response in
        let dictionary = response.dictionaryValue()
        print(dictionary?["name"])
}
```

#### Array Value

You might also want to get an array from the response, so you can use this:

```swift
service.json(
    method: .get,
    path: "/api/users",
    interceptor: interceptor) { response in
        let list = response.arrayValue()
        print(list?.first)
}
```

#### Decodable Value

Now here comes the real good thing. You can try to convert the response to any kind of `Decodable` objects. That will make your life easier in many ways. Let's say that your server can give a response with an object, a list of objects or an error object, all in the response body:

```swift
service.json(
    method: .get,
    path: "/api/users",
    interceptor: interceptor) { response in
        if let user = response.decodableValue(of: User.self) {
            showSingle(user: user)
        } else if let users = response.decodableValue(of: [User].self) {
            showList(of: users)
        } else if let error = response.decodableValue(of APIError.self) {
            showAn(error: error)
        }
}
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
