/// `Debuggable` provides an interface that allows a type
/// to be more easily debugged in the case of an error.
public protocol Debuggable: CustomDebugStringConvertible {
    
    /// The reason for the error.
    /// Typical implementations will switch over `self`
    /// and return a friendly `String` describing the error.
    /// - note: It is most convenient that `self` be a `Swift.Error`.
    ///
    /// Here is one way to do this:
    ///
    ///     switch self {
    ///     case someError:
    ///        return "A `String` describing what went wrong including the actual error: `Error.someError`."
    ///     // other cases
    ///     }
    var reason: String { get }

    // MARK: Identifiers

    /// A readable name for the error's Type. This is usually
    /// similar to the Type name of the error with spaces added.
    /// This will normally be printed proceeding the error's reason.
    static var readableName: String { get }

    /// Some unique identifier for the error's Type.
    /// note: This defaults to `ModuleName.TypeName`
    /// This will be used to create the `identifier` property.
    static var typeIdentifier: String { get }

    /// Some unique identifier for this specific error.
    /// This will be used to create the `identifier` property.
    var instanceIdentifier: String { get }

    /// The identifier that describes the specific error at hand
    /// for use in finding help online.
    /// - note: Default returns typeIdentifier.instanceIdentifier
    var identifier: String { get }

    // MARK: Help
    
    /// A `String` array describing the possible causes of the error.
    /// - note: Defaults to an empty array.
    /// Provide a custom implementation to give more context.
    var possibleCauses: [String] { get }
    
    /// A `String` array listing some common fixes for the error.
    /// - note: Defaults to an empty array.
    /// Provide a custom implementation to be more helpful.
    var suggestedFixes: [String] { get }
    
    /// An array of string `URL`s linking to documentation pertaining to the error.
    /// - note: Defaults to an empty array.
    /// Provide a custom implementation with relevant links.
    var documentationLinks: [String] { get }
    
    /// An array of string `URL`s linking to related Stack Overflow questions.
    /// - note: Defaults to an empty array.
    /// Provide a custom implementation to link to useful questions.
    var stackOverflowQuestions: [String] { get }
    
    /// An array of string `URL`s linking to related issues on Vapor's GitHub repo.
    /// - note: Defaults to an empty array.
    /// Provide a custom implementation to a list of pertinent issues.
    var gitHubIssues: [String] { get }
}

// MARK: Optionals

extension Debuggable {
    public var possibleCauses: [String] {
        return []
    }
    
    public var suggestedFixes: [String] {
        return []
    }
    
    public var documentationLinks: [String] {
        return []
    }
    
    public var stackOverflowQuestions: [String] {
        return []
    }
    
    public var gitHubIssues: [String] {
        return []
    }
}

// MARK: Defaults

extension Debuggable {
    public static var typeIdentifier: String {
        return String(reflecting: self)
    }

    public var identifier: String {
        return "\(Self.typeIdentifier).\(instanceIdentifier)"
    }

    public var debugDescription: String {
        return printable
    }
}


// MARK: Representations

extension Debuggable {
    /// A computed property returning a `String` that encapsulates
    /// why the error occurred, suggestions on how to fix the problem,
    /// and resources to consult in debugging (if these are available).
    /// - note: Consult the implementation of `generateDebugDescription()`
    /// in `Debuggable`'s protocol extension for details on how
    /// `log` is constructed by default.
    public var printable: String {
        var print: [String] = []

        print += "\(Self.readableName): \(reason)"
        print += "Identifier: \(identifier)"

        if !possibleCauses.isEmpty {
            print += "Here are some possible causes: \(possibleCauses.bulletedList)"
        }

        if !suggestedFixes.isEmpty {
            print += "These suggestions could address the issue: \(suggestedFixes.bulletedList)"
        }

        if !documentationLinks.isEmpty {
            print += "Vapor's documentation talks about this: \(documentationLinks.bulletedList)"
        }

        if !stackOverflowQuestions.isEmpty {
            print += "These Stack Overflow links might be helpful: \(stackOverflowQuestions.bulletedList)"
        }

        if !gitHubIssues.isEmpty {
            print += "See these Github issues for discussion on this topic: \(gitHubIssues.bulletedList)"
        }

        return print.joined(separator: "\n\n")
    }
}

func +=(lhs: inout [String], rhs: String) {
    lhs.append(rhs)
}

extension Array where Element == String {
    var bulletedList: String {
        return map({ "\n- \($0)" }).joined()
    }
}
