package br.ufscar.sead.loa.remar

class ExportedResource {
	static belongsTo = [owner: User, resource: Resource]
    static hasMany = [platforms: Platform, accounts: MoodleAccount]

    static constraints = {
    	moodleUrl nullable: true
    	linuxUrl nullable: true
    	windowsUrl nullable: true
    	webUrl nullable: true
    	androidUrl nullable: true
    }


    String moodleUrl
    String linuxUrl
    String windowsUrl
    String webUrl
    String androidUrl

    String name
    int width
    int height
    Date exportedAt

    String type //should be "public", "private" or "group"
    String processId
}
