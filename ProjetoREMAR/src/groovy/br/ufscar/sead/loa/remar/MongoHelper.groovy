package br.ufscar.sead.loa.remar

import com.mongodb.client.MongoDatabase
import com.mongodb.MongoClient
import org.bson.Document
import org.codehaus.groovy.grails.web.servlet.mvc.GrailsParameterMap


@Singleton
class MongoHelper {

    MongoClient mongoClient
    MongoDatabase db
    String dbName = 'remar'

    def init() {
        this.mongoClient = new MongoClient()
        this.db = mongoClient.getDatabase(dbName)
    }

    def createCollection(String collectionName) {
        def dbExists = false;

        db.listCollectionNames().each {
            if (it.equals(collectionName)) {
                dbExists = true
            }
        }

        if (!dbExists) {
            db.createCollection(collectionName)
            return false
        }

        return true
    }

    def insertData(String collection, Object data) {

        Document doc = new Document(data)

        println "Doc: "
        println doc
        println "Doc Type: "
        println doc.getClass()

        db.getCollection(collection).insertOne(doc)
    }

}
