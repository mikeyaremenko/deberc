import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

plugins {
	id("org.springframework.boot") version "3.0.3"
	id("io.spring.dependency-management") version "1.1.0"
	id("org.flywaydb.flyway") version "9.15.1"
	id("com.revolut.jooq-docker") version "0.3.9"
	kotlin("jvm") version "1.7.22"
	kotlin("plugin.spring") version "1.7.22"
}

group = "kharkov.card.games"
version = "0.0.1"
java.sourceCompatibility = JavaVersion.VERSION_17

repositories {
	mavenCentral()
}

dependencies {
	implementation("org.springframework.boot:spring-boot-starter-data-r2dbc")
	implementation("org.springframework.boot:spring-boot-starter-webflux")
	implementation("com.fasterxml.jackson.module:jackson-module-kotlin")
	implementation("io.projectreactor.kotlin:reactor-kotlin-extensions")
	implementation("org.jetbrains.kotlin:kotlin-reflect")
	implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8")
	implementation("org.jetbrains.kotlinx:kotlinx-coroutines-reactor")
	implementation("org.jooq:jooq:3.14.15")

	jdbc("org.postgresql:postgresql:42.2.5")

	runtimeOnly("org.postgresql:postgresql")
	runtimeOnly("org.postgresql:r2dbc-postgresql")
	testImplementation("org.springframework.boot:spring-boot-starter-test")
	testImplementation("io.projectreactor:reactor-test")
}

tasks.withType<KotlinCompile> {
	kotlinOptions {
		freeCompilerArgs = listOf("-Xjsr305=strict")
		jvmTarget = "17"
	}
}

tasks {
	generateJooqClasses {
		schemas = arrayOf("public", "other_schema")
		basePackageName = "org.jooq.generated"
		inputDirectory.setFrom(project.files("src/main/resources/db/migration"))
		outputDirectory.set(project.layout.buildDirectory.dir("generated-jooq"))
		flywayProperties = mapOf("flyway.placeholderReplacement" to "false")
		excludeFlywayTable = true
		outputSchemaToDefault = setOf("public")
		schemaToPackageMapping = mapOf("public" to "kharkov.deberc")
		customizeGenerator {
			/* "this" here is the org.jooq.meta.jaxb.Generator configure it as you please */
		}
	}
}

tasks.withType<Test> {
	useJUnitPlatform()
}
