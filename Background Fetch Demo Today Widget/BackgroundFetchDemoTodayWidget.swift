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

        let entry = SimpleEntry.loadSharedEntry()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {

        print("widget getTimeline")

        // Generate a timeline consisting of one entry.
        getSnapshot(in: context) { entry in

            let entries = [entry]

            var reloadPolicy: TimelineReloadPolicy = .never
            if let nextUpdate = Calendar.current.date(byAdding: .minute, value: 30, to: Date()) {
                reloadPolicy = .after(nextUpdate)
            }
            let timeline = Timeline(entries: entries, policy: reloadPolicy)

            completion(timeline)
        }
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


    static func loadSharedEntry() -> SimpleEntry {

        let sharedPokemonURL = CommonConstants.sharedURL(path: CommonConstants.demoContentPokemonJSON)
        let sharedPNGURL = CommonConstants.sharedURL(path: CommonConstants.demoContentPokemonImage)
        let sharedPokemon = SavedJSON(url: sharedPokemonURL)
        let sharedPNG = SavedPNG(url: sharedPNGURL)

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
        return Self.placeholder
    }
}

struct PlaceholderView: View {

    var body: some View {

        EntryView(entry: SimpleEntry.placeholder)
            .redacted(reason: .placeholder)
    }
}

struct EntryDetailView: View {

    static var dateFormatter: DateFormatter = {

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short

        return dateFormatter
    }()

    var entry: Provider.Entry

    var body: some View {

        VStack(alignment: .leading) {
            Text(entry.pokemon.name)
                .bold()
            Text(Self.dateFormatter.niceWrappingString(from: entry.pokemon.dateTime))
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
                .padding([.leading, .trailing, .bottom], 4)
        }
        .padding()
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
                .padding([.top, .bottom, .trailing], 4)
        }
    }
}

struct EntryView : View {

    @Environment(\.widgetFamily) var family: WidgetFamily
    var entry: Provider.Entry

    var body: some View {

        if #available(iOSApplicationExtension 17.0, *) {

            VStack {
                switch family {
                case .systemSmall: SmallEntryView(entry: entry)
                case .systemMedium: MediumEntryView(entry: entry)
                default: SmallEntryView(entry: entry)
                }
            }
            .containerBackground(.black, for: .widget)

        } else {

            switch family {
            case .systemSmall: SmallEntryView(entry: entry)
            case .systemMedium: MediumEntryView(entry: entry)
            default: SmallEntryView(entry: entry)
            }

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

#if DEBUG
struct BackgroundFetchDemoTodayWidget_Previews: PreviewProvider {

    static var previews: some View {

        Group {

            EntryView(entry: SimpleEntry.placeholder)
                .previewContext(WidgetPreviewContext(family: .systemMedium))

            EntryView(entry: SimpleEntry.placeholder)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
        }
    }
}
#endif

extension DateFormatter {

    static let NBSP: String = "\u{00a0}"

    func niceWrappingString(from date: Date) -> String {

        return
            self.string(from: date)
                .replacingOccurrences(of: " ", with: Self.NBSP)
                .replacingOccurrences(of: Self.NBSP + "at" + Self.NBSP, with: " at ")
    }
}
