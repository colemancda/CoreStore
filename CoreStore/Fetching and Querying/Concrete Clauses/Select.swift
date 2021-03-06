//
//  Select.swift
//  CoreStore
//
//  Copyright (c) 2015 John Rommel Estropia
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation
import CoreData


// MARK: - SelectResultType

/**
The `SelectResultType` protocol is implemented by return types supported by the `Select` clause.
*/
public protocol SelectResultType { }


// MARK: - SelectValueResultType

/**
The `SelectValueResultType` protocol is implemented by return types supported by the `queryValue(...)` methods.
*/
public protocol SelectValueResultType: SelectResultType {
    
    static func fromResultObject(result: AnyObject) -> Self?
}


// MARK: - SelectAttributesResultType

/**
The `SelectValueResultType` protocol is implemented by return types supported by the `queryAttributes(...)` methods.
*/
public protocol SelectAttributesResultType: SelectResultType {
    
    static func fromResultObjects(result: [AnyObject]) -> [[NSString: AnyObject]]
}


// MARK: - SelectTerm

/**
The `SelectTerm` is passed to the `Select` clause to indicate the attributes/aggregate keys to be queried.
*/
public enum SelectTerm: StringLiteralConvertible {
    
    // MARK: Public
    
    /**
    Provides a `SelectTerm` to a `Select` clause for querying an entity attribute. A shorter way to do the same is to assign from the string keypath directly:
    
        let fullName = CoreStore.queryValue(
            From(MyPersonEntity),
            Select<String>(.Attribute("fullName")),
            Where("employeeID", isEqualTo: 1111)
        )
    
    is equivalent to:
    
        let fullName = CoreStore.queryValue(
            From(MyPersonEntity),
            Select<String>("fullName"),
            Where("employeeID", isEqualTo: 1111)
        )
    
    :param: keyPath the attribute name
    :returns: a `SelectTerm` to a `Select` clause for querying an entity attribute
    */
    public static func Attribute(keyPath: KeyPath) -> SelectTerm {
        
        return ._Attribute(keyPath)
    }
    
    /**
    Provides a `SelectTerm` to a `Select` clause for querying the average value of an attribute.

        let averageAge = CoreStore.queryValue(
            From(MyPersonEntity),
            Select<Int>(.Average("age"))
        )
    
    :param: keyPath the attribute name
    :param: alias the dictionary key to use to access the result. Ignored when the query return value is not an `NSDictionary`. If `nil`, the default key "average(<attributeName>)" is used
    :returns: a `SelectTerm` to a `Select` clause for querying the average value of an attribute
    */
    public static func Average(keyPath: KeyPath, As alias: KeyPath? = nil) -> SelectTerm {
        
        return ._Aggregate(
            function: "average:",
            keyPath,
            As: alias ?? "average(\(keyPath))"
        )
    }
    
    /**
    Provides a `SelectTerm` to a `Select` clause for a count query.
    
        let numberOfEmployees = CoreStore.queryValue(
            From(MyPersonEntity),
            Select<Int>(.Count("employeeID"))
        )
    
    :param: keyPath the attribute name
    :param: alias the dictionary key to use to access the result. Ignored when the query return value is not an `NSDictionary`. If `nil`, the default key "count(<attributeName>)" is used
    :returns: a `SelectTerm` to a `Select` clause for a count query
    */
    public static func Count(keyPath: KeyPath, As alias: KeyPath? = nil) -> SelectTerm {
        
        return ._Aggregate(
            function: "count:",
            keyPath,
            As: alias ?? "count(\(keyPath))"
        )
    }
    
    /**
    Provides a `SelectTerm` to a `Select` clause for querying the maximum value for an attribute.
    
        let maximumAge = CoreStore.queryValue(
            From(MyPersonEntity),
            Select<Int>(.Maximum("age"))
        )
    
    :param: keyPath the attribute name
    :param: alias the dictionary key to use to access the result. Ignored when the query return value is not an `NSDictionary`. If `nil`, the default key "max(<attributeName>)" is used
    :returns: a `SelectTerm` to a `Select` clause for querying the maximum value for an attribute
    */
    public static func Maximum(keyPath: KeyPath, As alias: KeyPath? = nil) -> SelectTerm {
        
        return ._Aggregate(
            function: "max:",
            keyPath,
            As: alias ?? "max(\(keyPath))"
        )
    }
    
    /**
    Provides a `SelectTerm` to a `Select` clause for querying the median value for an attribute.
    
        let medianAge = CoreStore.queryValue(
            From(MyPersonEntity),
            Select<Int>(.Median("age"))
        )
    
    :param: keyPath the attribute name
    :param: alias the dictionary key to use to access the result. Ignored when the query return value is not an `NSDictionary`. If `nil`, the default key "max(<attributeName>)" is used
    :returns: a `SelectTerm` to a `Select` clause for querying the median value for an attribute
    */
    public static func Median(keyPath: KeyPath, As alias: KeyPath? = nil) -> SelectTerm {
        
        return ._Aggregate(
            function: "median:",
            keyPath, As:
            alias ?? "median(\(keyPath))"
        )
    }
    
    /**
    Provides a `SelectTerm` to a `Select` clause for querying the minimum value for an attribute.
    
        let minimumAge = CoreStore.queryValue(
            From(MyPersonEntity),
            Select<Int>(.Median("age"))
        )
    
    :param: keyPath the attribute name
    :param: alias the dictionary key to use to access the result. Ignored when the query return value is not an `NSDictionary`. If `nil`, the default key "min(<attributeName>)" is used
    :returns: a `SelectTerm` to a `Select` clause for querying the minimum value for an attribute
    */
    public static func Minimum(keyPath: KeyPath, As alias: KeyPath? = nil) -> SelectTerm {
        
        return ._Aggregate(
            function: "min:",
            keyPath,
            As: alias ?? "min(\(keyPath))"
        )
    }
    
    /**
    Provides a `SelectTerm` to a `Select` clause for querying the standard deviation value for an attribute.
    
        let stddevAge = CoreStore.queryValue(
            From(MyPersonEntity),
            Select<Int>(.StandardDeviation("age"))
        )
    
    :param: keyPath the attribute name
    :param: alias the dictionary key to use to access the result. Ignored when the query return value is not an `NSDictionary`. If `nil`, the default key "stddev(<attributeName>)" is used
    :returns: a `SelectTerm` to a `Select` clause for querying the standard deviation value for an attribute
    */
    public static func StandardDeviation(keyPath: KeyPath, As alias: KeyPath? = nil) -> SelectTerm {
        
        return ._Aggregate(
            function: "stddev:",
            keyPath,
            As: alias ?? "stddev(\(keyPath))"
        )
    }
    
    /**
    Provides a `SelectTerm` to a `Select` clause for querying the sum value for an attribute.
    
        let totalAge = CoreStore.queryValue(
            From(MyPersonEntity),
            Select<Int>(.Sum("age"))
        )
    
    :param: keyPath the attribute name
    :param: alias the dictionary key to use to access the result. Ignored when the query return value is not an `NSDictionary`. If `nil`, the default key "sum(<attributeName>)" is used
    :returns: a `SelectTerm` to a `Select` clause for querying the sum value for an attribute
    */
    public static func Sum(keyPath: KeyPath, As alias: KeyPath? = nil) -> SelectTerm {
        
        return ._Aggregate(
            function: "sum:",
            keyPath,
            As: alias ?? "sum(\(keyPath))"
        )
    }
    
    
    // MARK: StringLiteralConvertible
    
    public init(stringLiteral value: KeyPath) {
        
        self = ._Attribute(value)
    }
    
    public init(unicodeScalarLiteral value: KeyPath) {
        
        self = ._Attribute(value)
    }
    
    public init(extendedGraphemeClusterLiteral value: KeyPath) {
        
        self = ._Attribute(value)
    }
    
    
    // MARK: Internal
    
    case _Attribute(KeyPath)
    case _Aggregate(function: String, KeyPath, As: String)
}


// MARK: - Select

/**
The `Select` clause indicates the attribute / aggregate value to be queried. The generic type is a `SelectResultType`, and will be used as the return type for the query. 

You can bind the return type by specializing the initializer:

    let maximumAge = CoreStore.queryValue(
        From(MyPersonEntity),
        Select<Int>(.Maximum("age"))
    )

or by casting the type of the return value:

    let maximumAge: Int = CoreStore.queryValue(
        From(MyPersonEntity),
        Select(.Maximum("age"))
    )

Valid return types depend on the query:

- for `queryValue(...)` methods:
    - `Bool`
    - `Int8`
    - `Int16`
    - `Int32`
    - `Int64`
    - `Double`
    - `Float`
    - `String`
    - `NSNumber`
    - `NSString`
    - `NSDecimalNumber`
    - `NSDate`
    - `NSData`
    - `NSManagedObjectID`
    - `NSString`
- for `queryAttributes(...)` methods:
    - `NSDictionary`

:param: sortDescriptors a series of `NSSortDescriptor`'s
*/
public struct Select<T: SelectResultType> {
    
    // MARK: Public
    
    /**
    The `SelectResultType` type for the query's return value
    */
    public typealias ReturnType = T
    
    /**
    Initializes a `Select` clause with a list of `SelectTerm`'s
    
    :param: selectTerm a `SelectTerm`
    :param: selectTerms a series of `SelectTerm`'s
    */
    public init(_ selectTerm: SelectTerm, _ selectTerms: SelectTerm...) {
        
        self.selectTerms = [selectTerm] + selectTerms
    }


    // MARK: Internal

    internal func applyToFetchRequest(fetchRequest: NSFetchRequest) {
        
        if fetchRequest.propertiesToFetch != nil {
            
            CoreStore.log(.Warning, message: "An existing \"propertiesToFetch\" for the <\(NSFetchRequest.self)> was overwritten by \(typeName(self)) query clause.")
        }
        
        fetchRequest.includesPendingChanges = false
        fetchRequest.resultType = .DictionaryResultType
        
        let entityDescription = fetchRequest.entity!
        let propertiesByName = entityDescription.propertiesByName
        let attributesByName = entityDescription.attributesByName
        
        var propertiesToFetch = [AnyObject]()
        for term in self.selectTerms {
            
            switch term {
                
            case ._Attribute(let keyPath):
                if let propertyDescription = propertiesByName[keyPath] as? NSPropertyDescription {
                    
                    propertiesToFetch.append(propertyDescription)
                }
                else {
                    
                    CoreStore.log(.Warning, message: "The property \"\(keyPath)\" does not exist in entity <\(entityDescription.managedObjectClassName)> and will be ignored by \(typeName(self)) query clause.")
                }
                
            case ._Aggregate(let function, let keyPath, let alias):
                if let attributeDescription = attributesByName[keyPath] as? NSAttributeDescription {
                    
                    let expressionDescription = NSExpressionDescription()
                    expressionDescription.name = alias
                    expressionDescription.expressionResultType = attributeDescription.attributeType
                    expressionDescription.expression = NSExpression(
                        forFunction: function,
                        arguments: [NSExpression(forKeyPath: keyPath)]
                    )
                    
                    propertiesToFetch.append(expressionDescription)
                }
                else {
                    
                    CoreStore.log(.Warning, message: "The attribute \"\(keyPath)\" does not exist in entity <\(entityDescription.managedObjectClassName)> and will be ignored by \(typeName(self)) query clause.")
                }
            }
        }
        
        fetchRequest.propertiesToFetch = propertiesToFetch
    }
    
    internal func keyPathForFirstSelectTerm() -> KeyPath {
        
        switch self.selectTerms.first! {
            
        case ._Attribute(let keyPath):
            return keyPath
            
        case ._Aggregate(_, _, let alias):
            return alias
        }
    }
    
    
    // MARK: Private
    
    private let selectTerms: [SelectTerm]
}


// MARK: - Bool: SelectValueResultType

extension Bool: SelectValueResultType {
    
    public static var attributeType: NSAttributeType {
        
        return .BooleanAttributeType
    }
    
    public static func fromResultObject(result: AnyObject) -> Bool? {
        
        return (result as? NSNumber)?.boolValue
    }
}


// MARK: - Int8: SelectValueResultType

extension Int8: SelectValueResultType {
    
    public static var attributeType: NSAttributeType {
        
        return .Integer64AttributeType
    }
    
    public static func fromResultObject(result: AnyObject) -> Int8? {
        
        if let value = (result as? NSNumber)?.longLongValue {
            
            return numericCast(value) as Int8
        }
        return nil
    }
}


// MARK: - Int16: SelectValueResultType

extension Int16: SelectValueResultType {
    
    public static var attributeType: NSAttributeType {
        
        return .Integer64AttributeType
    }
    
    public static func fromResultObject(result: AnyObject) -> Int16? {
        
        if let value = (result as? NSNumber)?.longLongValue {
            
            return numericCast(value) as Int16
        }
        return nil
    }
}


// MARK: - Int32: SelectValueResultType

extension Int32: SelectValueResultType {
    
    public static var attributeType: NSAttributeType {
        
        return .Integer64AttributeType
    }
    
    public static func fromResultObject(result: AnyObject) -> Int32? {
        
        if let value = (result as? NSNumber)?.longLongValue {
            
            return numericCast(value) as Int32
        }
        return nil
    }
}


// MARK: - Int64: SelectValueResultType

extension Int64: SelectValueResultType {
    
    public static var attributeType: NSAttributeType {
        
        return .Integer64AttributeType
    }
    
    public static func fromResultObject(result: AnyObject) -> Int64? {
        
        return (result as? NSNumber)?.longLongValue
    }
}


// MARK: - Int: SelectValueResultType

extension Int: SelectValueResultType {
    
    public static var attributeType: NSAttributeType {
        
        return .Integer64AttributeType
    }
    
    public static func fromResultObject(result: AnyObject) -> Int? {
        
        if let value = (result as? NSNumber)?.longLongValue {
            
            return numericCast(value) as Int
        }
        return nil
    }
}


// MARK: - Double : SelectValueResultType

extension Double: SelectValueResultType {
    
    public static var attributeType: NSAttributeType {
        
        return .DoubleAttributeType
    }
    
    public static func fromResultObject(result: AnyObject) -> Double? {
        
        return (result as? NSNumber)?.doubleValue
    }
}


// MARK: - Float: SelectValueResultType

extension Float: SelectValueResultType {
    
    public static var attributeType: NSAttributeType {
        
        return .FloatAttributeType
    }
    
    public static func fromResultObject(result: AnyObject) -> Float? {
        
        return (result as? NSNumber)?.floatValue
    }
}


// MARK: - String: SelectValueResultType

extension String: SelectValueResultType {
    
    public static var attributeType: NSAttributeType {
        
        return .StringAttributeType
    }
    
    public static func fromResultObject(result: AnyObject) -> String? {
        
        return result as? NSString as? String
    }
}


// MARK: - NSNumber: SelectValueResultType

extension NSNumber: SelectValueResultType {
    
    public class var attributeType: NSAttributeType {
        
        return .Integer64AttributeType
    }
    
    public class func fromResultObject(result: AnyObject) -> Self? {
        
        func forceCast<T: NSNumber>(object: AnyObject) -> T? {
            
            return (object as? T)
        }
        return forceCast(result)
    }
}


// MARK: - NSString: SelectValueResultType

extension NSString: SelectValueResultType {
    
    public class var attributeType: NSAttributeType {
        
        return .StringAttributeType
    }
    
    public class func fromResultObject(result: AnyObject) -> Self? {
        
        func forceCast<T: NSString>(object: AnyObject) -> T? {
            
            return (object as? T)
        }
        return forceCast(result)
    }
}


// MARK: - NSDecimalNumber: SelectValueResultType

extension NSDecimalNumber: SelectValueResultType {
    
    public override class var attributeType: NSAttributeType {
        
        return .DecimalAttributeType
    }
    
    public override class func fromResultObject(result: AnyObject) -> Self? {
        
        func forceCast<T: NSDecimalNumber>(object: AnyObject) -> T? {
            
            return (object as? T)
        }
        return forceCast(result)
    }
}


// MARK: - NSDate: SelectValueResultType

extension NSDate: SelectValueResultType {
    
    public class var attributeType: NSAttributeType {
        
        return .DateAttributeType
    }
    
    public class func fromResultObject(result: AnyObject) -> Self? {
        
        func forceCast<T: NSDate>(object: AnyObject) -> T? {
            
            return (object as? T)
        }
        return forceCast(result)
    }
}


// MARK: - NSData: SelectValueResultType

extension NSData: SelectValueResultType {
    
    public class var attributeType: NSAttributeType {
        
        return .BinaryDataAttributeType
    }
    
    public class func fromResultObject(result: AnyObject) -> Self? {
        
        func forceCast<T: NSData>(object: AnyObject) -> T? {
            
            return (object as? T)
        }
        return forceCast(result)
    }
}


// MARK: - NSManagedObjectID: SelectValueResultType

extension NSManagedObjectID: SelectValueResultType {
    
    public class var attributeType: NSAttributeType {
        
        return .ObjectIDAttributeType
    }
    
    public class func fromResultObject(result: AnyObject) -> Self? {
        
        func forceCast<T: NSManagedObjectID>(object: AnyObject) -> T? {
            
            return (object as? T)
        }
        return forceCast(result)
    }
}


// MARK: - NSManagedObjectID: SelectAttributesResultType

extension NSDictionary: SelectAttributesResultType {
    
    // MARK: SelectAttributesResultType
    
    public class func fromResultObjects(result: [AnyObject]) -> [[NSString: AnyObject]] {
        
        return result as! [[NSString: AnyObject]]
    }
}
