/**
    Failure object for validation operations
*/
public class ValidationError: ErrorProtocol {
    public let message: String
    public init(message: String) {
        self.message = message
    }
}

public enum NameBetter<T: Validator> {
    case suite(T.Type)
    case validator(T)
}

public class ValidatorFailure<ValidatorType: Validator>: ValidationError {
    public let input: ValidatorType.InputType?
    public let validator: NameBetter<ValidatorType>

    public init(_ validator: ValidatorType, input: ValidatorType.InputType?, message: String? = nil) {
        self.input = input
        self.validator = .validator(validator)

        let inputDescription = input.flatMap { "\($0)" } ?? "nil"
        let message = message ?? "\(validator) failed with input: \(inputDescription)"
        super.init(message: message)
    }

    public init(_ type: ValidatorType.Type = ValidatorType.self, input: ValidatorType.InputType?, message: String? = nil) {
        self.input = input
        self.validator = .suite(type)

        let inputDescription = input.flatMap { "\($0)" } ?? "nil"
        let message = message ?? "\(type) failed with input: \(inputDescription)"
        super.init(message: message)
    }
}

extension Validator {
    /**
        Use this to conveniently throw errors within a ValidationSuite
        to indicate the point of failure.

        - parameter input: the value that caused the failure

        - returns: a ValidationFailure object to throw
    */
    public static func error(with input: InputType, message: String? = nil) -> ErrorProtocol {
        return ValidatorFailure(self, input: input, message: message)
    }

    /**
        Use this to conveniently throw errors within a Validator
        to indicate a point of failure

        - parameter input: the value that caused the failure

        - returns: a ValidationFailure object to throw
    */
    public func error(with input: InputType, message: String? = nil) -> ErrorProtocol {
        return ValidatorFailure(self, input: input, message: message)
    }
}
