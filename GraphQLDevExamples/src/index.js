const { ApolloServer } = require('apollo-server');

// 1  defines your GraphQL schema

const fs = require('fs');
const { parseValue } = require('graphql');
const path = require('path');


let memberlist = [{
    id: 0,
    name: 'Honeywell',
    region: 'West',
    level: 'Platinum',
    orgType: 'Industry',
    orgSize: 'Large'

}]
// 2 implementation of GraphQL schema
let idCount = memberlist.length

const resolvers = {
    
    Query: {
        info: () => 'Information',
        membership: () => memberlist,
        memberByID: (parent, args) => {
          return memberlist.find(Member => Member.id == args.id);
        },
    },
    Mutation: {
        createMember:(parent, args ) => {
            const member = {
                id: `${idCount++}`,
                name: args.name,
                region: args.region,
                level: args.level,
                orgType: args.orgType,
                orgSize: args.orgSize,
            }
            memberlist.push(member)
            return member
        },
        updateMember:(parent, args) => {
            let newMember = memberlist.find(Member => Member.id == args.id);
            if (!newMember) {
                  throw new Error('no member exists with id ' + args.id);
            } 
            if (args.name != null) {
                newMember.name = args.name;
            }
            
            if (args.region != null) {
               newMember.region = args.region;
	       console.log('Updating Region ' + args.region);
	    } 
            if (args.level != null) {
               newMember.level = args.level;
            }
            if (args.orgType != null) {
               newMember.orgType = args.orgType;
            }
            if (args.orgSize != null ) {
               newMember.orgSize = args.orgSize;
            }
            return newMember
        },
        deleteMember: (parent, args) => {
            const listIndex = memberlist.findIndex(Member => Member.id == args.id);
            if (listIndex == -1) {
                  throw new Error('no member exists with id ' + args.id);
            } 
            const deletedMember = memberlist.splice(listIndex, 1);
            return deletedMember[0];
        },
    },
}

// 3
// pass the schema and resolvers to the apollo-server
const server = new ApolloServer({
    typeDefs: fs.readFileSync(
        path.join(__dirname, 'schema.graphql'),
        'utf8'
    ),
    resolvers,
})

server
    .listen()
    .then(  ({ url } ) =>
        console.log(`Server is running on ${url}`)
    );
