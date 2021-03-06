//
//  LegacyCGGeometryFunctionsRule.swift
//  SwiftLint
//
//  Created by Blaise Sarr on 31/03/16.
//  Copyright © 2016 Realm. All rights reserved.
//

import SourceKittenFramework
import Foundation

public struct LegacyCGGeometryFunctionsRule: CorrectableRule, ConfigurationProviderRule {
    public var configuration = SeverityConfiguration(.Warning)

    public init() {}

    public static let description = RuleDescription(
        identifier: "legacy_cggeometry_functions",
        name: "Legacy CGGeometry Functions",
        description: "Struct extension properties and methods are preferred over legacy functions",
        nonTriggeringExamples: [
            "rect.width",
            "rect.height",
            "rect.minX",
            "rect.midX",
            "rect.maxX",
            "rect.minY",
            "rect.midY",
            "rect.maxY",
            "rect.isNull",
            "rect.isEmpty",
            "rect.isInfinite",
            "rect.standardized",
            "rect.integral",
            "rect.insetBy(dx: 5.0, dy: -7.0)",
            "rect.offsetBy(dx: 5.0, dy: -7.0)",
            "rect1.union(rect: rect2)",
            "rect1.intersect(rect: rect2)",
            // "rect.divide(atDistance: 10.2, fromEdge: edge)", No correction available for divide
            "rect1.contains(rect: rect2)",
            "rect.contains(point: point)",
            "rect1.intersects(rect: rect2)",
        ],
        triggeringExamples: [
            "↓CGRectGetWidth(rect)",
            "↓CGRectGetHeight(rect)",
            "↓CGRectGetMinX(rect)",
            "↓CGRectGetMidX(rect)",
            "↓CGRectGetMaxX(rect)",
            "↓CGRectGetMinY(rect)",
            "↓CGRectGetMidY(rect)",
            "↓CGRectGetMaxY(rect)",
            "↓CGRectIsNull(rect)",
            "↓CGRectIsEmpty(rect)",
            "↓CGRectIsInfinite(rect)",
            "↓CGRectStandardize(rect)",
            "↓CGRectIntegral(rect)",
            "↓CGRectInset(rect, 10, 5)",
            "↓CGRectOffset(rect, -2, 8.3)",
            "↓CGRectUnion(rect1, rect2)",
            "↓CGRectIntersection(rect1, rect2)",
            "↓CGRectContainsRect(rect1, rect2)",
            "↓CGRectContainsPoint(rect, point)",
            "↓CGRectIntersectsRect(rect1, rect2)"
        ],
        corrections: [
            "↓CGRectGetWidth( rect  )\n": "rect.width\n",
            "↓CGRectGetHeight(rect )\n": "rect.height\n",
            "↓CGRectGetMinX( rect)\n": "rect.minX\n",
            "↓CGRectGetMidX(  rect)\n": "rect.midX\n",
            "↓CGRectGetMaxX( rect)\n": "rect.maxX\n",
            "↓CGRectGetMinY(rect   )\n": "rect.minY\n",
            "↓CGRectGetMidY(rect )\n": "rect.midY\n",
            "↓CGRectGetMaxY( rect     )\n": "rect.maxY\n",
            "↓CGRectIsNull(  rect    )\n": "rect.isNull\n",
            "↓CGRectIsEmpty( rect )\n": "rect.isEmpty\n",
            "↓CGRectIsInfinite( rect )\n": "rect.isInfinite\n",
            "↓CGRectStandardize( rect)\n": "rect.standardized\n",
            "↓CGRectIntegral(rect )\n": "rect.integral\n",
            "↓CGRectInset(rect, 5.0, -7.0)\n": "rect.insetBy(dx: 5.0, dy: -7.0)\n",
            "↓CGRectOffset(rect, -2, 8.3)\n": "rect.offsetBy(dx: -2, dy: 8.3)\n",
            "↓CGRectUnion(rect1, rect2)\n": "rect1.union(rect: rect2)\n",
            "↓CGRectIntersection( rect1 ,rect2)\n": "rect1.intersect(rect: rect2)\n",
            "↓CGRectContainsRect( rect1,rect2     )\n": "rect1.contains(rect: rect2)\n",
            "↓CGRectContainsPoint(rect  ,point)\n": "rect.contains(point: point)\n",
            "↓CGRectIntersectsRect(  rect1,rect2 )\n": "rect1.intersects(rect: rect2)\n",
            "↓CGRectIntersectsRect(rect1, rect2 )\n↓CGRectGetWidth(rect  )\n":
            "rect1.intersects(rect: rect2)\nrect.width\n"
        ]
    )

    public func validateFile(file: File) -> [StyleViolation] {
        let functions = ["CGRectGetWidth", "CGRectGetHeight", "CGRectGetMinX", "CGRectGetMidX",
                         "CGRectGetMaxX", "CGRectGetMinY", "CGRectGetMidY", "CGRectGetMaxY",
                         "CGRectIsNull", "CGRectIsEmpty", "CGRectIsInfinite", "CGRectStandardize",
                         "CGRectIntegral", "CGRectInset", "CGRectOffset", "CGRectUnion",
                         "CGRectIntersection", "CGRectContainsRect", "CGRectContainsPoint",
                         "CGRectIntersectsRect"]

        let pattern = "\\b(" + functions.joinWithSeparator("|") + ")\\b"

        return file.matchPattern(pattern, withSyntaxKinds: [.Identifier]).map {
            StyleViolation(ruleDescription: self.dynamicType.description,
                severity: configuration.severity,
                location: Location(file: file, characterOffset: $0.location))
        }
    }

    public func correctFile(file: File) -> [Correction] {
        let varName = RegexHelpers.varNameGroup
        let twoVars = RegexHelpers.twoVars
        let twoVariableOrNumber = RegexHelpers.twoVariableOrNumber

        let patterns = [
            "CGRectGetWidth\\(\(varName)\\)": "$1.width",
            "CGRectGetHeight\\(\(varName)\\)": "$1.height",
            "CGRectGetMinX\\(\(varName)\\)": "$1.minX",
            "CGRectGetMidX\\(\(varName)\\)": "$1.midX",
            "CGRectGetMaxX\\(\(varName)\\)": "$1.maxX",
            "CGRectGetMinY\\(\(varName)\\)": "$1.minY",
            "CGRectGetMidY\\(\(varName)\\)": "$1.midY",
            "CGRectGetMaxY\\(\(varName)\\)": "$1.maxY",
            "CGRectIsNull\\(\(varName)\\)": "$1.isNull",
            "CGRectIsEmpty\\(\(varName)\\)": "$1.isEmpty",
            "CGRectIsInfinite\\(\(varName)\\)": "$1.isInfinite",
            "CGRectStandardize\\(\(varName)\\)": "$1.standardized",
            "CGRectIntegral\\(\(varName)\\)": "$1.integral",
            "CGRectInset\\(\(varName),\(twoVariableOrNumber)\\)": "$1.insetBy(dx: $2, dy: $3)",
            "CGRectOffset\\(\(varName),\(twoVariableOrNumber)\\)": "$1.offsetBy(dx: $2, dy: $3)",
            "CGRectUnion\\(\(twoVars)\\)": "$1.union(rect: $2)",
            "CGRectIntersection\\(\(twoVars)\\)": "$1.intersect(rect: $2)",
            "CGRectContainsRect\\(\(twoVars)\\)": "$1.contains(rect: $2)",
            "CGRectContainsPoint\\(\(twoVars)\\)": "$1.contains(point: $2)",
            "CGRectIntersectsRect\\(\(twoVars)\\)": "$1.intersects(rect: $2)"
            ]

        let description = self.dynamicType.description
        var corrections = [Correction]()
        var contents = file.contents

        let matches = patterns.map {
            (pattern, template) -> [(NSRange, String, String)] in
            let matches = file.matchPattern(pattern)
                .filter { $0.1.first == .Identifier }.map { ($0.0, pattern, template) }
            return matches
            }
            .flatten().sort { $0.0.location > $1.0.location } // reversed

        for (range, pattern, template) in matches {
            contents = regex(pattern).stringByReplacingMatchesInString(contents,
                                options: [], range: range, withTemplate: template)
            let location = Location(file: file, characterOffset: range.location)
            corrections.append(Correction(ruleDescription: description, location: location))
        }

        file.write(contents)
        return corrections
    }
}
