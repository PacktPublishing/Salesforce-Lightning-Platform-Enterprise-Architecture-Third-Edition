public class TestData {
    
	public static final String SEASONSDATA = 
			'{' +
				'"drivers" : [ ' +
					'{' +
						'"name" : "Lewis Hamilton",' + 
						'"nationality" : "British",' + 
						'"driverId" : "44",' + 
						'"twitterHandle" : "lewistwitter"' +
					'}' +
				'],' +
				'"seasons" : [ ' +
					'{' +
						'"year" : "2013",' +
						'"races" : [' +
							'{' +
								'"round" : 1,' +
								'"name" : "Spain",' +
								'"contestants" : [' +
									'{' +
										'"driverId" : "44",' +
										'"championshipPoints" : 44,' +
										'"dnf" : false,' +
										'"qualification1LapTime" : 123,' + 
										'"qualification2LapTime" : 124,' + 
										'"qualification3LapTime" : 125' + 
									'}' +
								']' +
							'}' +
						']' + 
					'}' +
				']' +
			'}';
}