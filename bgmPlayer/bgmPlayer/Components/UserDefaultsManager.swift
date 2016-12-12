import Foundation

class UserDefaultsManager {
    let userDefaults = NSUserDefaults.standardUserDefaults()
    let userDefaultKey: String
    
    init(
        userDefaultKey: String
    ) {
        self.userDefaultKey = userDefaultKey
    }

    func contain(videoId: String) -> Bool {
        let videos = get()
        for video in videos {
            if video.videoId == videoId {
                return true
            }
        }
        return false
    }
    
    func get() -> [Video] {
        var userDefaultsVideos: Dictionary<String, String> = [:]
        if let saveVideos = userDefaults.dictionaryForKey(userDefaultKey) as? Dictionary<String, String> {
            userDefaultsVideos = saveVideos
        }
        
        var videos: [Video] = []
        
        for (key, value) in userDefaultsVideos {
        
            var video = Video()
            video.videoId = key
            
            let videoArray = value.componentsSeparatedByString(",")
            
            video.title = videoArray[0]
            video.imageUrl = videoArray[1]
            video.publishedAt = videoArray[2]
            if let createDate = Double(videoArray[3]) {
                video.createDate = createDate
            }
            
            videos.append(video)
        }

        let sortedVideos = videos.sort { $0.createDate > $1.createDate }
        return sortedVideos
    }
    
    func save(video: Video) {
        var addVideo = video
        addVideo.createDate = NSDate().timeIntervalSince1970
        var userDefaultsVideos: Dictionary<String, String> = [:]
        if let saveVideos = userDefaults.dictionaryForKey(userDefaultKey) as? Dictionary<String, String> {
            userDefaultsVideos = saveVideos
        }
        
        userDefaultsVideos[addVideo.videoId] =
            addVideo.title + "," +
            addVideo.imageUrl + "," +
            addVideo.publishedAt + "," +
            String(addVideo.createDate)
        
        userDefaults.setObject(
            userDefaultsVideos,
            forKey: userDefaultKey
        )

    }
    
    func delete(videoId: String) {
        let videos = get()
        allDelete()
        for video in videos {
            if video.videoId != videoId {
                save(video)
            }
        }
    }
    
    func allDelete() {
        userDefaults.removeObjectForKey(userDefaultKey)
    }
}
