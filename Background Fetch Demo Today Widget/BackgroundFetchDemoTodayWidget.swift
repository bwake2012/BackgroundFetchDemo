//
//  BackgroundFetchDemoTodayWidget.swift
//  Background Fetch Demo Today Widget
//
//  Created by Bob Wakefield on 11/5/20.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry.placeholder
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {

        let entry = loadEntry()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {

        // Generate a timeline consisting of one entry.
        getSnapshot(in: context) { entry in

            let entries = [entry]

            let timeline = Timeline(entries: entries, policy: .never)

            completion(timeline)
        }
    }

    func loadEntry() -> SimpleEntry {

        let sharedPokemon = SharedJSON(appGroupIdentifier: CommonConstants.appGroupIdentifier, path: CommonConstants.demoContentPokemonJSON)
        let sharedPNG = SharedPNG(appGroupIdentifier: CommonConstants.appGroupIdentifier, path: CommonConstants.demoContentPokemonImage)

        let result: Result<PokemonFetchEntry, Error> = sharedPokemon.getObject()
        switch result {
        case .failure(let error):
            print("Pokemon entry error: \(error.localizedDescription)")
        case .success(let pokemonEntry):
            let result: Result<UIImage, Error> = sharedPNG.getImage()
            switch result {
            case .failure(let error):
                print("Pokemon image error: \(error.localizedDescription)")
            case .success(let image):
                return SimpleEntry(date: Date(), pokemon: pokemonEntry, image: image)
            }
        }
        return SimpleEntry.placeholder
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let pokemon: PokemonFetchEntry
    let image: UIImage

    static let placeholder =
        SimpleEntry(
            date: Date(),
            pokemon: PokemonFetchEntry(
                dateTime: Date(),
                isBackground: false,
                name: "Placeholder",
                pokemonID: -1
            ),
            image: UIImage(named: "Placeholder")!
        )
}

struct EntryDetailView: View {

    static var dateFormatter: DateFormatter = {

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short

        return dateFormatter
    }()

    var entry: Provider.Entry

    var body: some View {

        VStack(alignment: .leading) {
            Text(entry.pokemon.name)
                .bold()
            Text(Self.dateFormatter.string(from: entry.pokemon.dateTime))
                .font(.footnote)
                .minimumScaleFactor(0.75)
                .lineLimit(3)
            Text(entry.pokemon.isBackground ? "Background" : "Manual")
                .font(.footnote)
                .minimumScaleFactor(0.75)
        }
    }
}

struct SmallEntryView: View {

    var entry: Provider.Entry

    var body: some View {
        VStack {
            Image(uiImage: entry.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
            EntryDetailView(entry: entry)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        }.padding()
    }
}

struct MediumEntryView: View {

    var entry: Provider.Entry

    var body: some View {
        HStack {
            Image(uiImage: entry.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
            EntryDetailView(entry: entry)
                .frame(
                    minWidth: 0, maxWidth: .infinity,
                    minHeight: 0, maxHeight: .infinity)
        }
    }
}

struct EntryView : View {

    @Environment(\.widgetFamily) var family: WidgetFamily
    var entry: Provider.Entry

    var body: some View {
        switch family {
        case .systemSmall: SmallEntryView(entry: entry)
        case .systemMedium: MediumEntryView(entry: entry)
        default: SmallEntryView(entry: entry)
        }
    }
}

@main
struct BackgroundFetchDemoTodayWidget: Widget {

    let kind: String = CommonConstants.simpleDemoWidgetKind

    var body: some WidgetConfiguration {

        StaticConfiguration(kind: kind, provider: Provider()) { entry in

            EntryView(entry: entry)
        }
        .configurationDisplayName("Background Fetch")
        .description("This is a simple widget to display the latest Pokémon fetched in the background.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct BackgroundFetchDemoTodayWidget_Previews: PreviewProvider {

    static var previews: some View {

        EntryView(entry: SimpleEntry.placeholder)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
