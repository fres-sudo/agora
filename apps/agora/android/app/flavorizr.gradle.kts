import com.android.build.gradle.AppExtension

val android = project.extensions.getByType(AppExtension::class.java)

android.apply {
    flavorDimensions("env")

    productFlavors {
        create("dev") {
            dimension = "env"
            applicationId = "space.fres.agora.dev"
            resValue(type = "string", name = "app_name", value = "Agora Dev")
        }
        create("staging") {
            dimension = "env"
            applicationId = "space.fres.agora.stg"
            resValue(type = "string", name = "app_name", value = "Agora Staging")
        }
        create("prod") {
            dimension = "env"
            applicationId = "space.fres.agora"
            resValue(type = "string", name = "app_name", value = "Agora POS")
        }
    }

    buildFeatures.resValues = true
}