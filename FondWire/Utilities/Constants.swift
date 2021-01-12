//
//  Constants.swift
//  FondWire
//
//  Created by Edil Ashimov on 7/13/20.
//  Copyright © 2020 Edil Ashimov. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage


// MARK: - API
let STORAGE_REF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_images")
let STORAGE_ASSET_ICONS = STORAGE_REF.child("asset_icons")

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")
let REF_FEEDS = DB_REF.child("feeds")
let REF_ASSETS = DB_REF.child("assets")
let REF_ASSETS_MANAGERS = DB_REF.child("assets").child("managers")
let REF_FEEDS_ARTICLE = DB_REF.child("feeds").child("articles")
let REF_FEEDS_VIDEO = DB_REF.child("feeds").child("videos")
let REF_FEEDS_PODCAST = DB_REF.child("feeds").child("podcasts")
let REF_FEEDS_EVENT = DB_REF.child("feeds").child("events")



let REF_USER_TWEETS = DB_REF.child("user-tweets")

let defaults = UserDefaults.standard
let WELCOME_TEXT = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut ero labore et dolore."

let TITLE_INSIGHTS = "INSIGHTS"
let TITLE_EXPLORE = "EXPLORE"
let TITLE_MANAGE = "PARTNERS"

let DESCRIPTION_INSIGHTS = "Get the latest news, insights and rumours of your investments."
let DESCRIPTION_EXPLORE = "In-depth articles, video highlights, rumors, for your favorite asset managers."
let DESCRIPTION_MANAGE = "A selection of the Asset Manager."

let AGREEMENT_TEXT = "Assets, Inc is registered trademark in German Exchange Commission securities regulatory authority or body of the state. The content, site, App, and blog are provided for the sole purpose of enabling users to conduct investment research. Other uses of the Content are strictly prohibited."

let FEED_SAMPLE_TITLE = "Double Digit Success, Vanguard had a brand new agreement to purchase CABD which could be a great potential"
let FEED_SAMPLE_DESCRIPTION = "Todays was a great trading day for Global Opp. Fund, saw double digit growth since, plus with the new purchase of CABD we are forecasting a great investment potential…"

let feed3Body = "Bedingt durch die dynamische Verbreitung des Coronoa-Virus erwarten wir weiterhin ein Armdrücken zwischen Markt und Institutionen. Staaten begegnen den Verwerfungen mit umfangreichen, nie dagewesenen Fiskalprogrammen. Notenbanken senken die Leitzinsen und stellen Liquidität bereit./n/nBei allen Gegenmaßnahmen der unkonventionellen Art müssen wir uns dennoch klarmachen, dass ein Ende der Quarantäne und des Stillstands nur sinnvoll ist, wenn die – auch in Deutschland immer noch – exponentielle Verbreitung von Covid-19 eingedämmt werden kann. Dazu sind – bei Abwesenheit eines Impfmittels, einer wirksamen Medikation oder zumindest von verfügbaren Massentests – weiterhin wirtschaftlicher Stillstand und sozialer Abstand verordnet. An vorderster Front kämpfen in diesen Zeiten alle Beschäftigten im Gesundheitssystem, Virologen und Wissenschaftler sowie alle Menschen welche in systemkritischen Branchen arbeiten und dafür sorgen, dass unsere tagtägliche Grundversorgung sichergestellt ist./n/nDiesen Menschen gilt unser Respekt und Beifall!/n/nWährend das Virus die Schwächen unseres durchoptimierten Wirtschaftens aufzeigt, diskontieren die Finanzmärkte die Zeichen aus der Realwirtschaft bereits deutlich. In der Spitze notierte das globale Aktienbarometer über 30% leichter als zu Jahresbeginn, während Credit-Spreads sich deutlich weiteten und Ratingagenturen ihre Noten so schnell absenkten wie zuletzt in der Finanzkrise. Zugleich bewirkten die starken Mittelzuflüsse in US-Staatsanleihen auch dort Renditen zwischen 0 und weniger als 1% für Laufzeiten bis zu 20 Jahren. Insofern ist auch in dieser Währung der Zins auf absehbare Zeit keine Einkommensquelle mehr. Die Entwicklung am Zinsmarkt verwundert wenig bei einem Blick auf die Inflationserwartungen für in fünf Jahren. Diese sackten in den USA von 2% auf unter 1,3% und in Europa von ohnehin geringen 1,2% auf nur noch 0,7%, konnten sich aber von ihren Tiefstständen mittlerweile wieder etwas erholen. In den USA deutlicher als hierzulande, da die monetären und fiskalischen Programme dort aggressiver sind. Geringere Inflationserwartungen wecken bei Zentralbanken und Staaten Deflationsängste und bei Wirtschaftswissenschaftlern Erinnerungen an die 1930er Jahre. In Zeiten der Deflation sinken die Preise, was allerorten ein Anschwellen der Schuldenlasten mit sich bringt. Daher ist es verständlich, wie entschlossen die Institutionen im Kräftemessen um Inflation und Eindämmung der Wohlstandsverluste sind. Dennoch sind die Auswirkungen materielle, und es werden weltweit vermutlich einige Quartale Wertschöpfung ausfallen, wie auch schwach finanzierte Unternehmen weiterhin in rauer See sein werden./n/nDas Verhalten von Wandelanleihen ist unter diesen Umständen bisher vorbildlich gewesen. Die Partizipationsrate an den Kursverlusten betrug rund ein Drittel und war daher lehrbuchartig. Geholfen hat die stabile Zusammensetzung der Inhaber des Marktes, der zu zwei Dritteln aus direktionalen Investoren mit langfristigem Ansatz besteht. In unseren Fonds und Mandaten sind wir stets breit über alle Branchen und Regionen gestreut und halten überwiegend gute und sehr gute Schuldnerqualitäten. Die am schwersten betroffenen Sektoren wie Tourismus, Luftfahrt und Automobil, Gewerbeimmobilien sowie Öl und Gas sind nicht oder nur gering vorkommend in unseren Fonds allokiert./n/nUpdates zur aktuellen Situation an den Kapitalmärkten und der Entwicklung unserer Fonds erhalten Sie auch über unsere LinkedIn Seite. Ebenfalls können Sie sich für unseren Newsletter anmelden, in dem wir regelmäßig die Märkte und Salm Fonds beleuchten."


