import FluentPostgreSQL
import Authentication

final class User: PostgreSQLModel {
    var id: Int?
    var email: String
    var password: String

    init(id: Int? = nil, email: String, password: String) {
        self.id = id
        self.email = email
        self.password = password
    }
}

extension User: Migration {}
extension User: Content {}
extension User: SessionAuthenticatable {}

extension User: PasswordAuthenticatable {
    static var usernameKey: WritableKeyPath<User, String> {
        return \User.email
    }
    static var passwordKey: WritableKeyPath<User, String> {
        return \User.password
    }
}

extension User {
    var topics: Children<User, Topic> {
        return children(\.userID)
    }
}

extension User {
    func isValid() -> Bool {
        return isEmailValid() && isPasswordValid()
    }

    /// Email at minium looks like: a@b.de
    private func isEmailValid() -> Bool {
        let minLength = 6

        if
            email.range(of: "@") == nil ||
            email.range(of: ".") == nil ||
            email.count < minLength
        {
            return false
        }

        return true
    }

    /// Password must have minimum 8 characters
    private func isPasswordValid() -> Bool {
        let minLength = 8
        return password.count >= minLength
    }
}
