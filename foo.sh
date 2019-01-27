# beginning of file
# save the following to query.sh
curl -sS -X POST http://$1:8983/solr/SKG_Demo/query -d '&rows=0&q=*:*
&back=*:*
&json.facet={
    "drumpfs_comms" : {
        type: query,
        q : "'$2'",
        facet : {
            related : {
                type : terms,
                field : "text",
                limit : 100,
                mincount : 5,
                sort: {
                    relatedness : '$3'
                },
                facet: {
                    relatedness : "relatedness($q,$back)"
                }
            }
        }
    }
}'
# end of file

