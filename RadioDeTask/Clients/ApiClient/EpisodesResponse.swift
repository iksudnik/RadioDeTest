//
//  EpisodesResponse.swift
//  RadioDeTask
//
//  Created by Ilya Sudnik on 24.02.24.
//

import Foundation

struct EpisodesResponse: Decodable {
	let totalCount: Int
	let episodes: [Episode]
}

struct Episode: Decodable {
	let id: String
	let title: String
	let description: String
	let publishDate: TimeInterval
	let duration: TimeInterval
	let parentLogo300x300: String
	let url: String
	let isDownloaded: Bool
}

extension Episode {
	var publishDateFixed: Date {
		Date(timeIntervalSince1970: publishDate)
	}
}


// MARK: - Mock

extension Episode {
	static let mock1 = Self(id: "verbrechen_die-luge-von-den-glucklichen-huhnchen_c8a5d3c89b",
							title: "Die Lüge von den glücklichen Hühnchen",
							description: "Die Tierschutz-Marke Neuland verspricht ihren umweltsensiblen Kunden nur\nQualitätsfleisch aus artgerechter Haltung. Doch dann kam heraus: Statt\nEdel-Hähnchen verkaufte der Hauptlieferant übles Fleisch von Massenvieh…\n\nIn Folge 188 erzählt Anne Kunze, Kriminalreporterin der ZEIT, im\nGespräch mit dem Chefredakteur des Kriminalmagazins ZEIT Verbrechen,\nDaniel Müller, wie sie mit dem Fernglas auf nächtlichen Einsätzen einem\nungeheuren Skandal auf die Spur kam.\n\nDie neue Ausgabe des Kriminalmagazins ZEIT Verbrechen liegt am Kiosk und\nist hier online bestellbar. Sie möchten zwei Ausgaben zum\nKennenlernpreis testen? Dann klicken Sie hier.\n\nDer Artikel zum Thema (\"Der Betrug am guten Gewissen\" von Anne Kunze)\nist im April 2014 in der ZEIT erschienen.\n\nUnd zu unserem Newsletter geht's hier entlang.\n\n[ANZEIGE] Mehr über die Angebote unserer Werbepartnerinnen und -partner\nfinden Sie HIER\n\n[ANZEIGE] Falls Sie uns nicht nur hören, sondern auch lesen möchten,\ntesten Sie jetzt 4 Wochen kostenlos Die ZEIT. Hier geht's zum Angebot.\n",
							publishDate: 1708439400,
							duration: 2696,
							parentLogo300x300: "https://static.prod.radio-api.net/verbrechen/8f35e0356a01933141699e5f871e3707/logo_300x300.png",
							url: "https://zeitonline.simplecastaudio.com/b108e21b-c741-4c2d-bebc-7c4ff91d6b14/episodes/1387d0a5-653b-41a0-9e9a-35711387ca1b/audio/128/default.mp3/default.mp3_ywr3ahjkcgo_44801d18af6a3ae474cc343359c3daf4_43150323.mp3?aid=rss_feed%5Cu0026awCollectionId=b108e21b-c741-4c2d-bebc-7c4ff91d6b14%5Cu0026awEpisodeId=1387d0a5-653b-41a0-9e9a-35711387ca1b%5Cu0026feed=dnJhzmyN&hash_redirect=1&x-total-bytes=43150323&x-ais-classified=streaming&listeningSessionID=0CD_382_54__bc23f903c610a2bcdeae1e681bbc2c3cfd534829",
							isDownloaded: false)
	
	static let mock2 = Self(id: "verbrechen_die-ratte-hat-sich-noch-gewehrt_3a3229745e",
							title: "\"Die Ratte hat sich noch gewehrt\"",
							description: "Sandra liebt alles, was lebt – und doch bringt sie zwei Männer dazu, mit\nihr zusammen einen blutigen Mord zu begehen. Die beiden kennen das Opfer\nnicht einmal. Ein dritter Helfer lässt die Leiche verschwinden. Auch er\nhat nichts gegen den Toten. Was geht da vor sich?\n\nIn der Folge 149 sprechen Daniel Müller, Chefredakteur des\nKriminalmagazins ZEIT-Verbrechen, und Anne Kunze, Kriminalreporterin der\nZEIT, über einen Mord und unvorstellbare menschliche Abhängigkeiten.\n\nDie neue Ausgabe des Kriminalmagazins \"ZEIT Verbrechen\" liegt am Kiosk\nund ist hier online bestellbar. Sie möchten zwei Ausgaben zum\nKennenlernpreis testen? Dann klicken Sie hier.\n\nDer Text zur Folge (\"Kaltblütig\" von Daniel Müller) ist im Januar 2016\nin der ZEIT erschienen.\n\n[ANZEIGE] Mehr über die Angebote unserer Werbepartnerinnen und -partner\nfinden Sie HIER\n\n[ANZEIGE] Falls Sie uns nicht nur hören, sondern auch lesen möchten,\ntesten Sie jetzt 4 Wochen kostenlos Die ZEIT. Hier geht's zum Angebot.\n",
							publishDate: 1691501400,
							duration: 2312,
							parentLogo300x300: "https://static.prod.radio-api.net/verbrechen/8f35e0356a01933141699e5f871e3707/logo_300x300.png",
							url: "https://zeitonline.simplecastaudio.com/b108e21b-c741-4c2d-bebc-7c4ff91d6b14/episodes/a483b368-384e-4860-bd0a-664c752bfe8e/audio/128/default.mp3/default.mp3_ywr3ahjkcgo_891f524b1706aec7303004e63b685994_37709395.mp3?aid=rss_feed%5Cu0026awCollectionId=b108e21b-c741-4c2d-bebc-7c4ff91d6b14%5Cu0026awEpisodeId=a483b368-384e-4860-bd0a-664c752bfe8e%5Cu0026feed=dnJhzmyN&hash_redirect=1&x-total-bytes=37709395&x-ais-classified=streaming&listeningSessionID=0CD_382_54__fe96e605436c0d75a68f1f07896c68c1e1fd2eb7",
							isDownloaded: true)
}
