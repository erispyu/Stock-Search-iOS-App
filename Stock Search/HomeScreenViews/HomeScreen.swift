//
//  HomeScreen.swift
//  Stock Search
//
//  Created by 陈冲 on 11/23/20.
//

import SwiftUI

struct HomeScreen: View {
    @ObservedObject var searchBar: SearchBar = SearchBar()
    @EnvironmentObject var localLists: LocalListsInfo
    
    @ObservedObject var portfolioPrices: LocalPrices
    @ObservedObject var favoritesPrices: LocalPrices
    
    var body: some View {
        
        if (portfolioPrices.count > 0 && favoritesPrices.count > 0) {
            NavigationView {
                VStack {
                    ProgressView("Fetching Data...")
                }
                .navigationBarTitle("Stocks")
            }
        } else {
        NavigationView {
            List {
                if searchBar.text.isEmpty {
                    CurrDateCell()

                    Section(header: Text("PORTFOLIO")) {
                        NetWorthCell()
                        ForEach(localLists.portfolioStocks) { stock in
                            StockRow(prices: portfolioPrices, stock: stock)
                        }
                        .onMove(perform: movePortfolioStocks)
                    }

                    Section(header: Text("FAVORITES")) {
                        ForEach(localLists.favoritesStocks) { stock in
                            StockRow(prices: favoritesPrices, stock: stock)
                        }
                        .onMove(perform: moveFavoritesStocks)
                        .onDelete(perform: deleteFavoritesStocks)
                    }
                    TiingoLinkCell()
                } else {
                    if searchBar.text.count >= 3 {
                        SearchView(autocompleteStocks: AutocompleteStocks(input: searchBar.text))
                    }//length control
                }//if-else SearchBar
            }//List
            .navigationBarTitle(Text("Stocks"))
            .add(self.searchBar)
            .toolbar {
                EditButton()
            }
        }//NavigationView
        }//if-else ProgressView
    }
    
    func movePortfolioStocks(from: IndexSet, to: Int) {
        withAnimation {
            localLists.portfolioStocks.move(fromOffsets: from, toOffset: to)
            setLocalStocks(localStocks: localLists.portfolioStocks, listName: listNamePortfolio)
        }
    }

    func moveFavoritesStocks(from: IndexSet, to: Int) {
        withAnimation {
            localLists.favoritesStocks.move(fromOffsets: from, toOffset: to)
            setLocalStocks(localStocks: localLists.favoritesStocks, listName: listNameFavorites)
        }
    }

    func deleteFavoritesStocks(offsets: IndexSet) {
        withAnimation {
            localLists.favoritesStocks.remove(atOffsets: offsets)
            setLocalStocks(localStocks: localLists.favoritesStocks, listName: listNameFavorites)
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen(portfolioPrices: LocalPrices(listName: listNamePortfolio), favoritesPrices: LocalPrices(listName: listNameFavorites))
            .environmentObject(LocalListsInfo(portfolioStocks: getLocalStocks(listName: listNamePortfolio),
                                                  favoritesStocks: getLocalStocks(listName: listNameFavorites),
                                                  availableWorth: getAvailableWorth(),
                                                  netWorth: getNetWorth()))
    }
}

struct NetWorthCell: View {
    @EnvironmentObject var localLists: LocalListsInfo
    @State var netWorth = getNetWorth()
    let timer = Timer.publish(every: 15, on: .main, in: .common).autoconnect()
    var body: some View {
        VStack(alignment: .leading) {
            Text("Net Worth")
                .font(.title)
            Text("\(netWorth, specifier: "%.2f")")
                .font(.title)
                .fontWeight(.heavy)
        }
        .onReceive(timer) { time in
            print("Refreshing Net Worth")
            netWorth = getNetWorth()
        }
    }
}

struct TiingoLinkCell: View {
    var body: some View {
        HStack {
            Spacer()
            Link("Powered by Tiingo", destination: URL(string: "https://www.tiingo.com")!)
                .foregroundColor(Color.gray)
                .font(.footnote)
            Spacer()
        }
    }
}

struct SearchView: View {
    @ObservedObject var autocompleteStocks: AutocompleteStocks
    var body: some View {
        ForEach(autocompleteStocks.stocks) { stock in
            NavigationLink(destination: StockDetails(ticker: stock.ticker,
                                                     descriptionInfo: DescriptionInfo(ticker: stock.ticker),
                                                     latestPriceInfo: LatestPriceInfo(ticker: stock.ticker),
                                                     newsInfo: NewsInfo(ticker: stock.ticker),
                                                     isFavorited: stock.isFavorited)) {
                VStack(alignment: .leading) {
                    Text(stock.ticker)
                        .font(.title3)
                        .fontWeight(.heavy)
                    Text(stock.name)
                        .foregroundColor(Color.gray)
                }
            }
        }
    }
}
