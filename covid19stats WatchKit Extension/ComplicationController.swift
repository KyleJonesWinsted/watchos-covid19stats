//
//  ComplicationController.swift
//  covid19stats WatchKit Extension
//
//  Created by Kyle Jones on 4/1/20.
//  Copyright © 2020 Kyle Jones. All rights reserved.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.backward])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        let country = CountriesController.shared.countries.first ?? Country(name: "--")
        let longTotal = country.cases?.total?.withCommas() ?? "--"
        let shortTotal = country.shortTotalCases ?? "--"
        switch complication.family {
        case .circularSmall:
            let template = CLKComplicationTemplateCircularSmallSimpleText()
            template.textProvider = CLKTextProvider(format: shortTotal)
            let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(entry)
        case .extraLarge:
            let template = CLKComplicationTemplateExtraLargeStackText()
            template.line1TextProvider = CLKTextProvider(format: country.name)
            template.line2TextProvider = CLKTextProvider(format: shortTotal)
            template.highlightLine2 = true
            let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(entry)
        case .modularSmall:
            let template = CLKComplicationTemplateModularSmallStackText()
            template.line1TextProvider = CLKTextProvider(format: country.name)
            template.line2TextProvider = CLKTextProvider(format: shortTotal)
            let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(entry)
        case .modularLarge:
            let template = CLKComplicationTemplateModularLargeTallBody()
            template.headerTextProvider = CLKTextProvider(format: country.name)
            template.bodyTextProvider = CLKTextProvider(format: shortTotal)
            let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(entry)
        case .utilitarianSmall:
            let template = CLKComplicationTemplateUtilitarianSmallFlat()
            template.textProvider = CLKTextProvider(format: shortTotal)
            let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(entry)
        case .utilitarianSmallFlat:
            let template = CLKComplicationTemplateUtilitarianSmallFlat()
            template.textProvider = CLKTextProvider(format: shortTotal)
            let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(entry)
        case .utilitarianLarge:
            let template = CLKComplicationTemplateUtilitarianLargeFlat()
            template.textProvider = CLKTextProvider(format: "\(country.name) - \(longTotal)")
            let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(entry)
        case .graphicCorner:
            let template = CLKComplicationTemplateGraphicCornerStackText()
            template.innerTextProvider = CLKTextProvider(format: longTotal)
            template.outerTextProvider = CLKTextProvider(format: country.name)
            let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(entry)
        case .graphicBezel:
            let template = CLKComplicationTemplateGraphicBezelCircularText()
            let circularTemplate = CLKComplicationTemplateGraphicCircularStackText()
            circularTemplate.line1TextProvider = CLKTextProvider(format: country.name)
            circularTemplate.line2TextProvider = CLKTextProvider(format: shortTotal)
            template.textProvider = CLKTextProvider(format: "\(country.name) - \(longTotal)")
            template.circularTemplate = circularTemplate
            let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(entry)
        case .graphicCircular:
            let template = CLKComplicationTemplateGraphicCircularStackText()
            template.line1TextProvider = CLKTextProvider(format: country.name)
            template.line2TextProvider = CLKTextProvider(format: shortTotal)
            let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(entry)
        case .graphicRectangular:
            let template = CLKComplicationTemplateGraphicRectangularStandardBody()
            template.headerTextProvider = CLKTextProvider(format: "COVID-19 Stats")
            template.body1TextProvider = CLKTextProvider(format: country.name)
            template.body2TextProvider = CLKTextProvider(format: longTotal)
            let entry = CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)
            handler(entry)
        @unknown default:
            handler(nil)
        }
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after to the given date
        handler(nil)
    }
    
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
        handler(nil)
    }
    
}
