//
//  SearchModel.swift
//  AppStoreClone
//
//  Created by JosephNK on 2018. 10. 25..
//  Copyright © 2018년 JosephNK. All rights reserved.
//

import UIKit

struct SearchModel: Codable {
    //let resultCount: Int?
    let results: [SearchResultModel]?
    
    private enum CodingKeys: String, CodingKey {
        case results = "results"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let results = try container.decode([SearchResultModel].self, forKey: .results)
        
        self.results = results
    }
}

struct SearchResultModel: Codable {
    
    let isGameCenterEnabled: Bool?
    let screenshotUrls: [String]?
    let ipadScreenshotUrls: [String]?
    let appletvScreenshotUrls: [String]?
    let artworkUrl60: String?
    let artworkUrl512: String?
    let artworkUrl100: String?
    let artistViewUrl: String?
    let advisories: [String]?
    let supportedDevices: [String]?
    let kind: String?
    let features: [String]?
    let averageUserRatingForCurrentVersion: Double?
    let trackCensoredName: String?
    let languageCodesISO2A: [String]?
    let fileSizeBytes: Int64?
    let sellerUrl: String?
    let contentAdvisoryRating: String?
    let userRatingCountForCurrentVersion: Int?
    let trackViewUrl: String?
    let trackContentRating: String?
    let sellerName: String?
    let primaryGenreId: String?
    let currentVersionReleaseDate: Date?
    let isVppDeviceBasedLicensingEnabled: Bool?
    let genreIds: [String]?
    let releaseNotes: String?
    let minimumOsVersion: String?
    let primaryGenreName: String?
    let releaseDate: Date?
    let currency: String?
    let wrapperType: String?
    let version: String?
    let description: String?
    let artistId: String?
    let artistName: String?
    let genres: [String]?
    let price: Double?
    let bundleId: String?
    let trackId: String?
    let trackName: String?
    let formattedPrice: String?
    let averageUserRating: Double?
    let userRatingCount: Int64?
    
    private enum CodingKeys: String, CodingKey {
        case isGameCenterEnabled = "isGameCenterEnabled"
        case screenshotUrls = "screenshotUrls"
        case ipadScreenshotUrls = "ipadScreenshotUrls"
        case appletvScreenshotUrls = "appletvScreenshotUrls"
        case artworkUrl60 = "artworkUrl60"
        case artworkUrl512 = "artworkUrl512"
        case artworkUrl100 = "artworkUrl100"
        case artistViewUrl = "artistViewUrl"
        case advisories = "advisories"
        case supportedDevices = "supportedDevices"
        case kind = "kind"
        case features = "features"
        case averageUserRatingForCurrentVersion = "averageUserRatingForCurrentVersion"
        case trackCensoredName = "trackCensoredName"
        case languageCodesISO2A = "languageCodesISO2A"
        case fileSizeBytes = "fileSizeBytes"
        case sellerUrl = "sellerUrl"
        case contentAdvisoryRating = "contentAdvisoryRating"
        case userRatingCountForCurrentVersion = "userRatingCountForCurrentVersion"
        case trackViewUrl = "trackViewUrl"
        case trackContentRating = "trackContentRating"
        case sellerName = "sellerName"
        case primaryGenreId = "primaryGenreId"
        case currentVersionReleaseDate = "currentVersionReleaseDate"
        case isVppDeviceBasedLicensingEnabled = "isVppDeviceBasedLicensingEnabled"
        case genreIds = "genreIds"
        case releaseNotes = "releaseNotes"
        case minimumOsVersion = "minimumOsVersion"
        case primaryGenreName = "primaryGenreName"
        case releaseDate = "releaseDate"
        case currency = "currency"
        case wrapperType = "wrapperType"
        case version = "version"
        case description = "description"
        case artistId = "artistId"
        case artistName = "artistName"
        case genres = "genres"
        case price = "price"
        case bundleId = "bundleId"
        case trackId = "trackId"
        case trackName = "trackName"
        case formattedPrice = "formattedPrice"
        case averageUserRating = "averageUserRating"
        case userRatingCount = "userRatingCount"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let isGameCenterEnabled = try? container.decodeSafe(Bool.self, forKey: .isGameCenterEnabled)
        let screenshotUrls = try? container.decodeSafe([String].self, forKey: .screenshotUrls)
        let ipadScreenshotUrls = try? container.decodeSafe([String].self, forKey: .ipadScreenshotUrls)
        let appletvScreenshotUrls = try? container.decodeSafe([String].self, forKey: .appletvScreenshotUrls)
        let artworkUrl60 = try? container.decodeSafe(String.self, forKey: .artworkUrl60)
        let artworkUrl512 = try? container.decodeSafe(String.self, forKey: .artworkUrl512)
        let artworkUrl100 = try? container.decodeSafe(String.self, forKey: .artworkUrl100)
        let artistViewUrl = try? container.decodeSafe(String.self, forKey: .artistViewUrl)
        let advisories = try? container.decodeSafe([String].self, forKey: .advisories)
        let supportedDevices = try? container.decodeSafe([String].self, forKey: .supportedDevices)
        let kind = try? container.decodeSafe(String.self, forKey: .kind)
        let features = try? container.decodeSafe([String].self, forKey: .features)
        let averageUserRatingForCurrentVersion = try? container.decodeSafe(Double.self, forKey: .averageUserRatingForCurrentVersion)
        let trackCensoredName = try? container.decodeSafe(String.self, forKey: .trackCensoredName)
        let languageCodesISO2A = try? container.decodeSafe([String].self, forKey: .languageCodesISO2A)
        let fileSizeBytes = try? container.decodeSafe(Int64.self, forKey: .fileSizeBytes)
        let sellerUrl = try? container.decodeSafe(String.self, forKey: .sellerUrl)
        let contentAdvisoryRating = try? container.decodeSafe(String.self, forKey: .contentAdvisoryRating)
        let userRatingCountForCurrentVersion = try? container.decodeSafe(Int.self, forKey: .userRatingCountForCurrentVersion)
        let trackViewUrl = try? container.decodeSafe(String.self, forKey: .trackViewUrl)
        let trackContentRating = try? container.decodeSafe(String.self, forKey: .trackContentRating)
        let sellerName = try? container.decodeSafe(String.self, forKey: .sellerName)
        let primaryGenreId = try? container.decodeSafe(String.self, forKey: .primaryGenreId)
        let currentVersionReleaseDate = try? container.decodeSafe(String.self, forKey: .currentVersionReleaseDate)
        let isVppDeviceBasedLicensingEnabled = try? container.decodeSafe(Bool.self, forKey: .isVppDeviceBasedLicensingEnabled)
        let genreIds = try? container.decodeSafe([String].self, forKey: .genreIds)
        let releaseNotes = try? container.decodeSafe(String.self, forKey: .releaseNotes)
        let minimumOsVersion = try? container.decodeSafe(String.self, forKey: .minimumOsVersion)
        let primaryGenreName = try? container.decodeSafe(String.self, forKey: .primaryGenreName)
        let releaseDate = try? container.decodeSafe(String.self, forKey: .releaseDate)
        let currency = try? container.decodeSafe(String.self, forKey: .currency)
        let wrapperType = try? container.decodeSafe(String.self, forKey: .wrapperType)
        let version = try? container.decodeSafe(String.self, forKey: .version)
        let description = try? container.decodeSafe(String.self, forKey: .description)
        let artistId = try? container.decodeSafe(String.self, forKey: .artistId)
        let artistName = try? container.decodeSafe(String.self, forKey: .artistName)
        let genres = try? container.decodeSafe([String].self, forKey: .genres)
        let price = try? container.decodeSafe(Double.self, forKey: .price)
        let bundleId = try? container.decodeSafe(String.self, forKey: .bundleId)
        let trackId = try? container.decodeSafe(String.self, forKey: .trackId)
        let trackName = try? container.decodeSafe(String.self, forKey: .trackName)
        let formattedPrice = try? container.decodeSafe(String.self, forKey: .formattedPrice)
        let averageUserRating = try? container.decodeSafe(Double.self, forKey: .averageUserRating)
        let userRatingCount = try? container.decodeSafe(Int64.self, forKey: .userRatingCount)
        
        self.isGameCenterEnabled = isGameCenterEnabled ?? false
        self.screenshotUrls = screenshotUrls ?? []
        self.ipadScreenshotUrls = ipadScreenshotUrls ?? []
        self.appletvScreenshotUrls = appletvScreenshotUrls ?? []
        self.artworkUrl60 = artworkUrl60 ?? ""
        self.artworkUrl512 = artworkUrl512 ?? ""
        self.artworkUrl100 = artworkUrl100 ?? ""
        self.artistViewUrl = artistViewUrl ?? ""
        self.advisories = advisories ?? []
        self.supportedDevices = supportedDevices ?? []
        self.kind = kind ?? ""
        self.features = features ?? []
        self.averageUserRatingForCurrentVersion = averageUserRatingForCurrentVersion ?? 0.0
        self.trackCensoredName = trackCensoredName ?? ""
        self.languageCodesISO2A = languageCodesISO2A ?? []
        self.fileSizeBytes = fileSizeBytes ?? 0
        self.sellerUrl = sellerUrl ?? ""
        self.contentAdvisoryRating = contentAdvisoryRating ?? ""
        self.userRatingCountForCurrentVersion = userRatingCountForCurrentVersion ?? 0
        self.trackViewUrl = trackViewUrl ?? ""
        self.trackContentRating = trackContentRating ?? ""
        self.sellerName = sellerName ?? ""
        self.primaryGenreId = primaryGenreId ?? ""
        self.currentVersionReleaseDate = Date.convertAppleStringToDate(currentVersionReleaseDate ?? "")
        self.isVppDeviceBasedLicensingEnabled = isVppDeviceBasedLicensingEnabled ?? false
        self.genreIds = genreIds ?? []
        self.releaseNotes = releaseNotes ?? ""
        self.minimumOsVersion = minimumOsVersion ?? ""
        self.primaryGenreName = primaryGenreName ?? ""
        self.releaseDate = Date.convertAppleStringToDate(releaseDate ?? "")
        self.currency = currency ?? ""
        self.wrapperType = wrapperType ?? ""
        self.version = version ?? ""
        self.description = description ?? ""
        self.artistId = artistId ?? ""
        self.artistName = artistName ?? ""
        self.genres = genres ?? []
        self.price = price ?? 0.0
        self.bundleId = bundleId ?? ""
        self.trackId = trackId ?? ""
        self.trackName = trackName ?? ""
        self.formattedPrice = formattedPrice ?? ""
        self.averageUserRating = averageUserRating ?? 0.0
        self.userRatingCount = userRatingCount ?? 0
    }
    
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////


enum SearchInfoListExpandState {
    case collapsed
    case expanded
}

struct SearchInfoListModel {
    
    let title: String?
    let subtitle: String?
    let desc: String?
    var useExpand: Bool = false
    var expandState: SearchInfoListExpandState = .collapsed
    
    init(title: String?, subtitle: String?, desc: String? = nil, useExpand: Bool = false, expandState: SearchInfoListExpandState = .collapsed) {
        self.title = title
        self.subtitle = subtitle
        self.desc = desc
        self.useExpand = useExpand
        self.expandState = expandState
    }
    
    static func makeListFromItem(_ item: SearchResultModel) -> [SearchInfoListModel] {
        let sellerName = item.sellerName ?? ""
        let fileSizeBytes = item.fileSizeBytes ?? 0
        let genres = item.genres ?? []
        let supportedDevices = item.supportedDevices ?? []
        let languageCodesISO2A = item.languageCodesISO2A ?? []
        let trackContentRating = item.trackContentRating ?? ""
        let artistName = item.artistName ?? ""
        let minimumOsVersion = item.minimumOsVersion ?? ""
        
        let fileSizeBytesString = String.convertMBFormatter(fileSizeBytes)
        
        let sellerTitle = NSLocalizedString("Seller", comment: "")
        let sizeTitle = NSLocalizedString("Size", comment: "")
        let categoryTitle = NSLocalizedString("Category", comment: "")
        let compatibilityTitle = NSLocalizedString("Compatibility", comment: "")
        let langTitle = NSLocalizedString("Language", comment: "")
        let ageTitle = NSLocalizedString("Age", comment: "")
        let copyrightTitle = NSLocalizedString("Copyright", comment: "")
        
        var results: [SearchInfoListModel] = [
            SearchInfoListModel.init(title: sellerTitle, subtitle: sellerName),
            SearchInfoListModel.init(title: sizeTitle, subtitle: fileSizeBytesString),
        ]
        if genres.count > 0 {
            let genre = genres[safe: 0]
            results.append(SearchInfoListModel.init(title: categoryTitle, subtitle: genre))
        } else {
            results.append(SearchInfoListModel.init(title: categoryTitle, subtitle: ""))
        }
        if supportedDevices.count > 0 {
            let subtitle = String.convertCompatibleDisplay(compatibleVersion: minimumOsVersion)
            let desc = String.convertDeviceInfo(compatibleDevices: supportedDevices, compatibleVersion: minimumOsVersion)
            results.append(SearchInfoListModel.init(title: compatibilityTitle, subtitle: subtitle, desc: desc, useExpand: true))
        } else {
            results.append(SearchInfoListModel.init(title: compatibilityTitle, subtitle: "", desc: ""))
        }
        if languageCodesISO2A.count > 0 {
            let result = String.conventLanguageCodesISO2A(keys: languageCodesISO2A)
            results.append(SearchInfoListModel.init(title: langTitle, subtitle: result.title, desc: result.desc, useExpand: (result.langCount == 0) ? false : true))
        } else {
            results.append(SearchInfoListModel.init(title: langTitle, subtitle: "", desc: ""))
        }
        results.append(SearchInfoListModel.init(title: ageTitle, subtitle: trackContentRating))
        results.append(SearchInfoListModel.init(title: copyrightTitle, subtitle: artistName))
        
        return results
    }
    
}
