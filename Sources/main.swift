import Foundation
import CoreFoundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

// Define the URL and payload
let url = URL(string: "https://gren-remote-auth-demo.21stcenturyalchemy.tech/users/auth/sign-up")!
let json: [String: Any] = [
    "email": "test@test.com",
    "password": "helloworld",
    "firstName": "test",
    "lastName": "test"
]

// Convert the payload to JSON data
let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])

// Create the request
var request = URLRequest(url: url)
request.httpMethod = "POST"
request.setValue("application/json", forHTTPHeaderField: "Content-Type")
request.httpBody = jsonData

let semaphore = DispatchSemaphore(value: 0)

// Perform the request
let task = URLSession.shared.dataTask(with: request) { data, response, error in
    if let error = error {
        print("Error: \(error)")
        return
    }

    if let response = response as? HTTPURLResponse {
        print("Response status code: \(response.statusCode)")
    }

    if let data = data, let responseBody = String(data: data, encoding: .utf8) {
        print("Response body: \(responseBody)")
    }

    semaphore.signal()
}

task.resume()
semaphore.wait()
