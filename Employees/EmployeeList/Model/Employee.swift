//
//  Employee.swift
//  Employees
//
//  Created by Tarsem Singh on 25/11/22.
//

struct APIResponse: Codable{
    var employees: [Employee]
}
struct Employee: Codable{
    var uuid: String
    var full_name: String
    var phone_number: String?
    var email_address: String
    var biography: String?
    var photo_url_small: String?
    var photo_url_large: String?
    var team: String
    var employee_type: String
}
