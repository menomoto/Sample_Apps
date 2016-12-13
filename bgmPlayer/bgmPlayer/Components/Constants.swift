import Foundation

struct Constants
{
    static let apiKey = ""
    static let searchTableViewCellHeight = 92
    static let categoryTableViewCellHeight = 48
    
    static let searchUrl = "https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=50&key=\(Constants.apiKey)&q=bgm+"
    
    static let bgmCategoryName = [
        "作業用",     //1430000
        "メドレー",   //514000
        "ゲーム",     //371000
        "ピアノ",    //309000
        "ジャズ",    //156000
        "ギター",    //138000
        "勉強用",    //120000
        "癒し",     //107000
        "カフェ",   //81200
        "クラシック", //61100
        "リラックス", //60700
        "ドラマ",    //56900
        "洋楽",     //55900
        "ドライブ",  //55000
        "ホテル",    //54000
        "テンション", //53900
        "クリスマス", //53200
        "ボサノバ",   //46400
        "ジブリ",   //44400
        "ディズニー", //40300
        "トランス",  //27900
        "邦楽",     //27100
        
    ]
}
