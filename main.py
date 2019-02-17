from bottle import route, run, response, template
from bottle import static_file
import json, requests

stop_words = ["enough", "i", "me", "my", "myself", "we", "our", "ours", "ourselves", "you", "your", "yours", "yourself", "yourselves", "he", "him", "his", "himself", "she", "her", "hers", "herself", "it", "its", "itself", "they", "them", "their", "theirs", "themselves", "what", "which", "who", "whom", "this", "that", "these", "those", "am", "is", "are", "was", "were", "be", "been", "being", "have", "has", "had", "having", "do", "does", "did", "doing", "a", "an", "the", "and", "but", "if", "or", "because", "as", "until", "while", "of", "at", "by", "for", "with", "about", "against", "between", "into", "through", "during", "before", "after", "above", "below", "to", "from", "up", "down", "in", "out", "on", "off", "over", "under", "again", "further", "then", "once", "here", "there", "when", "where", "why", "how", "all", "any", "both", "each", "few", "more", "most", "other", "some", "such", "no", "nor", "not", "only", "own", "same", "so", "than", "too", "very", "s", "t", "can", "will", "just", "don", "should", "now"]

# static file handling
@route('/img/<filename:re:.*\.png>')
def send_image(filename):
    return static_file(filename, root='img', mimetype='image/png')

@route('/js/<filename:re:.*\.js>')
def send_static(filename):
	return static_file(filename, root='js', mimetype='application/javascript')

@route('/css/<filename:re:.*\.css>')
def send_static(filename):
	return static_file(filename, root='css', mimetype='text/css')


# site routes
@route('/')
def site():
    response.content_type = 'text/html'
    return template('index')


# API routes
@route('/skg/<topic>')
def skg(topic='wall'):
	ip = "35.245.83.229" # mechanics
	ip = "35.233.218.158" # cooking

	url = "http://%s:8983/solr/SKG_Demo/query" % ip
	order = "desc"
	payload = {'rows':0,'q':'*:*','back':'*:*','json.facet': "{'stack_exchange':{type:query,q:'%s',facet:{related:{type:terms,field:'post_text_t',limit:35,mincount:5,sort:{relatedness:'%s'},facet:{relatedness:'relatedness($q,$back)'}}}}}" % (topic,order)}
	
	r = requests.post(url, data=payload)

	response.content_type = 'application/json'
	return r.text

@route('/stopwords')
def stopwords():
	response.content_type = 'application/json'
	return json.dumps(stop_words)

@route('/img/<topic>')
def img(topic="black holes"):
	url = "https://www.googleapis.com/customsearch/v1?q=%s&cx=000990987861368802728:dqgj7kzrtpe&imgSize=medium&imgType=photo&num=10&searchType=image&key=AIzaSyCrySw4Hb7U2cVMWEry_wbgCjpn5idCbrc" % topic
	r = requests.get(url)
	response.content_type = 'application/json'
	return r.text

@route('/search/<topic>')
def search(topic='wall'):
	response.content_type = 'application/json'
	return json.dumps('{"foo": 1, "topic": "%s"}' % topic)


run(host='localhost', port=8080, debug=True)
